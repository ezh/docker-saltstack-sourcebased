FROM python:3.6-slim

MAINTAINER Alexey Aksenov <ezh@ezh.msk.ru>

ARG GOSU_VERSION=1.10
ARG SALT_BRANCH=develop
ARG TARGET=/opt/saltstack
ENV TARGET=$TARGET
ENV DEBIAN_FRONTEND noninteractive

RUN mkdir -p ${TARGET}
RUN apt-get update -y && apt-get install -y --no-install-recommends bash git curl
RUN python -m venv --copies /opt/saltstack
RUN git clone --branch "${SALT_BRANCH}" --depth 1000 --recursive https://github.com/saltstack/salt.git
RUN apt-get install -y --no-install-recommends libffi-dev openssl g++ make autoconf automake curl patch gnupg

SHELL ["/bin/bash", "-c"]

# Fetch dump-init
RUN curl -Lo ${TARGET}/dumb-init.deb https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64.deb
# Fetch gosu
RUN curl -Lo ${TARGET}/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)"
RUN curl -Lo /tmp/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc"
RUN export GNUPGHOME="$(mktemp -d)" \
  && gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
  && gpg --batch --verify /tmp/gosu.asc ${TARGET}/bin/gosu \
  && chmod +x ${TARGET}/bin/gosu

COPY pip.req /
RUN source ${TARGET}/bin/activate && pip install --upgrade pip setuptools \
  && pip install -r /pip.req \
  && pip install -r /salt/requirements/base.txt \
  && pip install -r /salt/requirements/zeromq.txt

COPY *.patch /
RUN patch --verbose /salt/salt/grains/core.py < /core.py.patch
RUN cd /salt/salt && patch --verbose -p1 < /auth.patch

RUN source ${TARGET}/bin/activate && cd /salt/ && python3 setup.py --salt-root-dir=${TARGET} install

FROM python:3.6.4-slim

ARG TARGET=/opt/saltstack
ARG UID=1000
ARG GID=1000
ENV UID=$UID
ENV GID=$GID
ENV TARGET=$TARGET
ENV DEBIAN_FRONTEND noninteractive
ENV PATH=${TARGET}/bin:$PATH

SHELL ["/bin/bash", "-c"]

COPY --from=0 ${TARGET} ${TARGET}

RUN mkdir -p ${TARGET}/srv/salt && mkdir -p ${TARGET}/var/log/salt && mkdir -p ${TARGET}/var/run/salt
RUN apt-get update -y && apt-get install -y --no-install-recommends apt-utils \
  && apt-get install -y --no-install-recommends libffi6 openssl \
  && apt-get install -y --no-install-recommends iproute2 net-tools lsof socat pciutils nano \
  && apt-get install -y --no-install-recommends git openssh-client \
  && apt-get clean
RUN echo $'#!/bin/bash\n#\necho docker' > /usr/local/bin/virt-what && chmod a+rx /usr/local/bin/virt-what
RUN dpkg -i ${TARGET}/dumb-init.deb && rm ${TARGET}/dumb-init.deb
RUN groupadd -g ${GID} salt
RUN useradd -r -s /bin/bash -u $UID -g ${GID} -d ${TARGET} salt

COPY entrypoint.sh /entrypoint.sh

EXPOSE 4505
EXPOSE 4506

VOLUME ["${TARGET}/etc/salt", "${TARGET}/var/log/salt", "${TARGET}/var/run/salt", , "${TARGET}/var/cache/salt"]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["$TARGET/bin/salt-master", "-l", "info"]
