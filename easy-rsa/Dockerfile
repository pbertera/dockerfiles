FROM alpine:latest

RUN apk update && apk add easy-rsa
RUN mkdir /easy-rsa && ln -s /usr/share/easy-rsa /er

ENV LOCAL_EASYRSA           /easy-rsa
ENV EASYRSA                /usr/share/easy-rsa
ENV EASYRSA_SSL_CONF       "$EASYRSA/openssl-1.0.cnf"
ENV EASYRSA_PKI            "$LOCAL_EASYRSA/pki"
ENV EASYRSA_DN              "org"

ENTRYPOINT ["/er/easyrsa"]
