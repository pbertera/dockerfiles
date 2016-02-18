# Docker runner

Docker runner is a script to easly manage a pool of containers. The containers pool is defined ina JSON file, each container belonging to a pool use the same image.
For each instance you can define customised options, like port bindings, volumnes and all the options defined by an [host_config](https://docker-py.readthedocs.org/en/latest/hostconfig/) object. Each instance can have also dedicated environment variables.

For each instance you can define pre, post and failure exec command hooks.

## Pool definition

- **image**: defines the containsers image
- **docker_url**: the Docker daemon socket
- **logging**: a Python logging.config definition ([DictConfig](https://docs.python.org/2/library/logging.config.html) from the JSON)
- **pool**: the container pool array
- **pool[].id**: the container instance name, must be unique
- **pool[].environment**: an array of environment variables passed to the container
- **pool[].host_config**: the [host_config](https://docker-py.readthedocs.org/en/latest/hostconfig/) dictionary for the container instance
- **pool[].pre_run_command**: a command to be executed before starting the container
- **pool[].post_run_command**: a command to be executed after the container start
- **pool[].failed_run_command**: a command to execute in case of run failure

### Example

The following JSON configures a pool of **pbertera/ldapserver** containers:

```
{
    "image": "pbertera/ldapserver",
    "docker_url": "unix://var/run/docker.sock",
    "logging": {
        "version": 1,
        "formatters": {
            "simple": {
                "format": "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
            }
        },
        "handlers": {
            "console": {
                "formatter": "simple",
                "class": "logging.StreamHandler",
                "level": "INFO",
                "stream": "ext://sys.stdout"
            }
        },
        "root": {
            "level": "DEBUG",
            "handlers": ["console"]
        }
    },
    "pool": [
        {
            "id": "ldap1",
            "environment": {
                "LDAP_DOMAIN": "ldap1.example.com",
                "LDAP_ORGANISATION": "Ldap1",
                "LDAP_ROOTPASS": "s3cr3tpassw0rd"
            },
            "host_config": {"port_bindings": {"389": 2389, "80": 2081}},
            "post_run_command": ["echo", "Listening on 2389 for LDAP and 2081 Web LDAP-Admin\nCredentials: admin DN: dc=ldap1,dc=example,dc=com, admin pass s3cr3tpassw0rd"]
        },
        {
            "id": "ldap2",
            "environment": {
                "LDAP_DOMAIN": "ldap2.example.com",
                "LDAP_ORGANISATION": "Ldap2",
                "LDAP_ROOTPASS": "s3cr3tpassw0rd"
            },
            "host_config": {"port_bindings": {"389": 2390, "80": 2082}},
            "post_run_command": ["echo", "Listening on 2390 for LDAP and 2082 Web LDAP-Admin\nCredentials: admin DN: dc=ldap2,dc=example,dc=com, admin pass s3cr3tpassw0rd"]
        }
    ]
}
```

## Executing:

**Run the first free container in a pool:**

```
sudo ./docker-runner -c ldap.json run
```

**Run a specific container instance:**

```
sudo ./docker-runner -c ldap.json run --id ldap2
```

**List all the running containers in a pool:**

```
sudo ./docker-runner -c ldap.json ls
```

**Kill a container:**

```
sudo ./docker-runner -c ldap.json kill --id ldap2
```

## Running in Docker

**Build the container**

```
sudo docker build -t pbertera/docker-runner .
```

**Run the container**

You have to mount the Docker daemon socket and the volume containing the pool definitions and then you can run the container:

```
$ sudo docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v $PWD:/data pbertera/docker-runner -c ldap.json ls
2016-02-17 22:39:49,106 - root - INFO - Container /ldap2 is running
2016-02-17 22:39:49,107 - root - INFO - Container /ldap1 is running

$ sudo docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v $PWD:/data pbertera/docker-runner -c ldap.json kill --id ldap1
2016-02-17 22:40:15,037 - root - INFO - Container ldap1 stopped
2016-02-17 22:40:15,059 - root - WARNING - Containter ldap1 removed
```

## SSH Wrapper

**.ssh/authorized_keys**

```
command="/opt/docker-runner/ssh-wrapper.sh",no-port-forwarding,no-agent-forwarding,no-X11-forwarding ssh-dss [... your SSH public key here ...]
```
