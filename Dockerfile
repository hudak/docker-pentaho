FROM hudak/oracle-java7

MAINTAINER Nick Hudak nhudak@pentaho.com

# Install SSH Server
RUN apt-get update && apt-get -y install openssh-server && mkdir -p /var/run/sshd
EXPOSE 22

# Install visualization libraries and utilities
RUN apt-get install -y xterm firefox

# Add pentaho user
RUN useradd --create-home -s /bin/bash pentaho
# Grand sudo privlidges
RUN apt-get install sudo && echo "pentaho ANY = NOPASSWD: ANY" 

# Install startup script
ADD init.sh /
RUN chmod u+x /init.sh

# Start Service
CMD ["/init.sh"]
