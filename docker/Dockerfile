FROM alpine:3.5

MAINTAINER Alexey Aksenov <ezh@ezh.msk.ru>

ARG version=fabric
# Install container dependencies
RUN apk add --no-cache bash git libffi-dev openssl-dev python3-dev linux-headers g++ && \
    pip3 install --upgrade pip && \
    git clone --branch "${version}" --depth 1 --recursive https://github.com/ezh/salt.git && \
    echo $'\n\
Jinja2\n\
MarkupSafe\n\
PyYAML\n\
boto3\n\
boto>=2.32.1\n\
docker-py\n\
futures>=2.0\n\
moto>=0.3.6\n\
msgpack-python>0.3\n\
paramiko\n\
pycrypto>=2.6.1\n\
python-dateutil\n\
pyzmq>=2.2.0\n\
requests>=1.0.0\n\
toolz\n\
tornado>=4.2.1\n\
\n' >> /salt/pip.req && \
    pip install -r /salt/pip.req && \
    echo http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
    apk --no-cache add virt-what && \
    cd /salt/ && python3 setup.py install && cd / && rm -rf /salt && \
    mkdir -p /etc/salt && mkdir -p /var/log/salt && mkdir -p /var/run/salt && echo > /etc/salt/master

EXPOSE 4505
EXPOSE 4506

SHELL ["/bin/bash", "-c"]

VOLUME ["/etc/salt", "/var/log/salt", "/var/run/salt"]

CMD ["/usr/bin/salt-master", "-l", "info"]
