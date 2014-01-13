FROM hudak/oracle-java7

MAINTAINER Nick Hudak nhudak@pentaho.com

# Install SSH Server
RUN apt-get update && apt-get -y install openssh-server && mkdir -p /var/run/sshd
EXPOSE 22

# Add pentaho user
RUN useradd --create-home -s /bin/bash pentaho

# Install startup script
ADD init.sh /
RUN chmod u+x /init.sh

#FOR DEBUGGING
RUN apt-get install -y xterm

# Start Service
CMD ["/init.sh"]
