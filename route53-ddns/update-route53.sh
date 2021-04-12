#!/bin/bash

usage=$(cat <<"EOF"
Usage:
    ./update-route53.sh [--help] --record=<record_set_name>
                        [--ttl=<ttl_seconds>] [--type=<record_type>]
                        --zone=<zone_id>
Update an AWS Route 53 record with your external IP address.
OPTIONS
    --help
        Show this output
    --record=<record_set_name>
        The name of the record set to update (e.g., hello.example.com).
    --ttl=<ttl_seconds>
        The TTL (in seconds) to set on the DNS record. Defaults to 300.
    --type=<record_type>
        The type of the record set to be updated (e.g., A, AAAA). Defaults to A.
    --zone=<zone_id>
        The zone id of the domain to be updated (e.g., ABCD12EFGH3IJ).
    --profile=<profile_name>
        The name of the `awscli` profile to use, if any (e.g., testing).
        (See: https://github.com/aws/aws-cli#getting-started)
EOF
)

SHOW_HELP=0
ZONEID=""
RECORDSET=""
PROFILE=""
PROFILEFLAG=""
TYPE="A"
TTL=300
COMMENT="Auto updating @ `date`"

while [ $# -gt 0 ]; do
    case "$1" in
        --help)
            SHOW_HELP=1
            ;;
        --record=*)
            RECORDSET="${1#*=}"
            ;;
        --ttl=*)
            TTL="${1#*=}"
            ;;
        --type=*)
            TYPE="${1#*=}"
            ;;
        --zone=*)
            ZONEID="${1#*=}"
            ;;
        --profile=*)
            PROFILE="${1#*=}"
            ;;
        *)
            SHOW_HELP=1
    esac
    shift
done

if [  -z "$RECORDSET" -o -z "$ZONEID" ]; then
    SHOW_HELP=1
fi

if [ $SHOW_HELP -eq 1 ]; then
    echo "$usage"
    exit 0
fi

if [ -n "$PROFILE" ]; then
    PROFILEFLAG="--profile $PROFILE"
fi

# Get the external IP address from OpenDNS (more reliable than other providers)
IP=`dig +short myip.opendns.com @resolver1.opendns.com`

# Get the current ip address on AWS
# Requires jq to parse JSON output
AWSIP="$(
   aws $PROFILEFLAG route53 list-resource-record-sets \
      --hosted-zone-id "$ZONEID" --start-record-name "$RECORDSET" \
      --start-record-type "$TYPE" --max-items 1 \
      --output json | jq -r \ '.ResourceRecordSets[].ResourceRecords[].Value'
)"


function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

IPFILE="/tmp/update-route53__${ZONEID}__${RECORDSET}__.ip"

if ! valid_ip $IP; then
    echo "Invalid IP address: $IP"
    exit 1
fi

# Check if the IP has changed
if [ ! -f "$IPFILE" ]
    then
    touch "$IPFILE"
fi
#compare local IP to dns of recordset
if [ "$IP" ==  "$AWSIP" ]; then
    # code if found
    # echo "IP is still $IP. Exiting"
    exit 0
else
    echo "IP has changed to $IP"
    # Fill a temp file with valid JSON
    TMPFILE=$(mktemp /tmp/temporary-file.XXXXXXXX)
    cat > ${TMPFILE} << EOF
    {
      "Comment":"$COMMENT",
      "Changes":[
        {
          "Action":"UPSERT",
          "ResourceRecordSet":{
            "ResourceRecords":[
              {
                "Value":"$IP"
              }
            ],
            "Name":"$RECORDSET",
            "Type":"$TYPE",
            "TTL":$TTL
          }
        }
      ]
    }
EOF

    # Update the Hosted Zone record
    aws $PROFILEFLAG route53 change-resource-record-sets \
        --hosted-zone-id $ZONEID \
        --change-batch file://"$TMPFILE" \
        --query '[ChangeInfo.Comment, ChangeInfo.Id, ChangeInfo.Status, ChangeInfo.SubmittedAt]'

    # Clean up
    rm $TMPFILE
fi

# All Done - cache the IP address for next time
echo "$IP" > "$IPFILE"
