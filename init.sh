#!/bin/sh
echo "Starting pentaho app environment"

# Create new user password
pass=`</dev/urandom tr -dc A-Za-z0-9 | head -c 8`
echo "Generated new 'pentaho' user password: $pass"
echo "pentaho:$pass" | chpasswd

# Start server
/usr/sbin/sshd -D
