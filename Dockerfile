FROM hudak/oracle-java7

MAINTAINER Nick Hudak nhudak@pentaho.com

# Install SSH Server
RUN apt-get update && apt-get -y install openssh-server && mkdir -p /var/run/sshd

# Install visualization libraries and utilities
RUN apt-get install -y xterm firefox libwebkitgtk-1.0-0

# Add pentaho user
RUN useradd --create-home -s /bin/bash pentaho
# Grand sudo privlidges
RUN apt-get install sudo -y && \
	echo "pentaho ALL = (root) NOPASSWD: $(which bash),$(which apt-get)" >>/etc/sudoers
# Setup ssh auth
RUN mkdir ~pentaho/.ssh && touch ~pentaho/.ssh/authorized_keys && \
	chown -R pentaho:pentaho ~pentaho/.ssh && \
	chmod -R u=rwX,go= ~pentaho/.ssh

# Install startup script
ADD init.sh /
RUN chmod u+x /init.sh

# Start Service
CMD ["/init.sh"]
EXPOSE 22
