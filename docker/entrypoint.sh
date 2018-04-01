#!/bin/bash
#

# chown $UID:$GID $TARGET
CONTAINER_UID=$(/usr/bin/stat -c "%u" $TARGET/.keep 2>/dev/null)
CONTAINER_GID=$(/usr/bin/stat -c "%g" $TARGET/.keep 2>/dev/null)
USER=$({ getent passwd $UID 2>/dev/null || echo salt; } | cut -d: -f1 )
GROUP=$({ getent group $GID 2>/dev/null || echo salt; } | cut -d: -f1)
RUN=$(eval "echo $@")
echo Running '"'$RUN'"'
echo "SaltStack root $TARGET, User ID: ($USER:$UID), Group ID: ($GROUP:$GID)"

test -e $TARGET/etc/salt/init && source $TARGET/etc/salt/init

if [[ $UID -eq 0 && $GID -eq 0 ]]
then
  chown -R salt:salt $TARGET
  exec "/usr/bin/dumb-init" -- $RUN
else
  { test -e $TARGET/.keep && test "$UID" -eq "$CONTAINER_UID" && test "$GID" -eq "$CONTAINER_GID" ;} || {
    touch $TARGET/.keep
    echo Set user '"'$USER'"' UID to $UID
    usermod -u $UID $USER
    echo Set group '"'$GROUP'"' GID to $GID
    groupmod -g $GID $GROUP
    chown -R $USER:$GROUP $TARGET
  }
  exec gosu $USER:$GROUP "/usr/bin/dumb-init" -- $RUN
fi
