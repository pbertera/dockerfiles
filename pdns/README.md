# PoweDNS Docker

PowerDNS running in a docker container with SQLite backend

This container is inspired by [this one](https://github.com/renan/powerdns-docker).

## Running the service

Running the service with a custom API key (if `API_KEY` is not provided the key is `changeme`).

```
docker run -it -e API_KEY=MyAPIKey -p 80:80 -p 53:53 -p 53:53/udp pbertera/pdns
```

### Using a permanent storage file

Zone database is store in `/data/pdns.db` you can mount a volume over it:

```
docker run -it -v $(pwd)/pdns.db:/data/pdns.db -e API_KEY=MyAPIKey -p 80:80 -p 53:53 -p 53:53/udp pbertera/pdns
```

## Creating the first zone

Create the zone:

```
curl -X POST --data '{"name":"example.org.", "kind": "Native", "masters": [], "nameservers": ["ns1.example.org.", "ns2.example.org."]}' -v -H 'X-API-Key: MyAPIKey' http://127.0.0.1:80/api/v1/servers/localhost/zones
```

Add a record:

```
curl -X PATCH --data '{"rrsets": [ {"name": "test.example.org.", "type": "A", "ttl": 86400, "changetype": "REPLACE", "records": [ {"content": "192.0.5.4", "disabled": false } ] } ] }' -H 'X-API-Key: MyAPIKey' http://127.0.0.1:80/api/v1/servers/localhost/zones/example.org
```

Dig the domain:

```
dig example.org @127.0.0.1
```

More documentation about the PowerDNS REST API is [here](https://doc.powerdns.com/md/httpapi/README/)
