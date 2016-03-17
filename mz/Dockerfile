FROM debian

RUN apt-get update && apt-get install -y \
    mz \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "mz" ]
