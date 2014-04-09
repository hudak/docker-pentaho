#!/bin/bash
echo "Check for installed ssh keys"
authKeys=~pentaho/.ssh/authorized_keys
if [[ ! -f $authKeys ]]; then
	mkdir -p $(dirname $authKeys) && >$authKeys
	chown -R pentaho:pentaho $(dirname $authKeys)
	echo "pentaho user does not have ssh keys installed"
	echo Paste in rsa public key
	while read line; do
		[[ $line == "ssh-rsa "* ]] && echo $line >>$authKeys
	done
	if [[ ! -s $authKeys ]]; then
		echo "No keys read in"
		echo "Pipe keys in with <~/.ssh/id_rsa.pub docker run -a stdin -i ..."
		echo "or paste interactively with docker run -i -t ..."
		exit 1
	fi
fi

echo "Starting services"
service postgresql start

touch /docker_running
while [[ -f /docker_running ]]; do
	pgrep sshd >/dev/null || { $(which sshd); echo Started sshd; }
	sleep 1
done
echo Done

