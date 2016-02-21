# Easy-rsa Docker container

this container runs the easy-rsa OpenVPN script in a container

## Example:

```
is_running () 
{ 
    local name=$1;
    local state=$(docker inspect --format "{{.State.Running}}" $name 2>/dev/null);
    if [[ "$state" == "true" ]]; then
        return 0;
    else
        return -1;
    fi
}

bailout () 
{ 
    echo $@
}

del_stopped () 
{ 
    local name=$1;
    local state=$(docker inspect --format "{{.State.Running}}" $name 2>/dev/null);
    if [[ "$state" == "false" ]]; then
        docker rm $name;
    fi
}

## easy-rsa function: mount the $EASY_RSA_PKI:/easy-rsa into /easy-rsa, if $EASY_RSA_PKI exists load it as a variables file
easy-rsa () 
{ 
    local name=easy-rsa;
    local env_file="";
    if is_running $name; then
        bailout "Container $name is already running";
        return;
    fi;
    del_stopped $name;
    if [ -f "$EASY_RSA_PKI/vars" ]; then
        env_file="--env-file $EASY_RSA_PKI/vars";
    fi;
    docker run --rm -it -v $EASY_RSA_PKI:/easy-rsa ${env_file} --name ${name} pbertera/easy-rsa $@
}
```
