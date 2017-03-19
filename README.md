docker-saltstack-sourcebased
=======================
[![Build Status](https://travis-ci.org/ezh/docker-saltstack-sourcebased.png?branch=master)](https://travis-ci.org/ezh/docker-saltstack-sourcebased) [![Pulls](https://img.shields.io/docker/pulls/ezh1k/saltstack.svg)](https://hub.docker.com/r/ezh1k/saltstack/) [![Releases](https://img.shields.io/github/release/ezh/docker-saltstack-sourcebased.svg)](https://github.com/ezh/docker-saltstack-sourcebased/releases) [![License](https://img.shields.io/github/license/ezh/docker-saltstack-sourcebased.svg)](https://github.com/ezh/docker-saltstack-sourcebased/blob/master/LICENSE)

Source based SaltStack on Alpine linux with Python 3

SaltStack build from source from https://github.com/ezh/salt

By default it builds the specific version [![Releases](https://img.shields.io/github/release/ezh/docker-saltstack-sourcebased.svg)](https://github.com/ezh/docker-saltstack-sourcebased/releases) if you use docker compose and latest unstable *fabric* if you build directly from Dockerfile.

[Hint #1](https://github.com/ezh/docker-saltstack-sourcebased/blob/master/docker/Dockerfile#L5),
[Hint #2](https://github.com/ezh/docker-saltstack-sourcebased/blob/master/docker-compose.travis.yml#L7)

Execution
---------

Salt master executed directly as PID 1 process with logging to `STDOUT` and /var/log/salt/master.

Copyright
---------

Copyright © 2017 Alexey B. Aksenov/Ezh. All rights reserved.
