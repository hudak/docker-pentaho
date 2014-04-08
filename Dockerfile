#Dockerfile
FROM dockerfile/java
MAINTAINER Nick Hudak nhudak@pentaho.com

RUN apt-get update

# Install useful command line utilities
RUN apt-get -y install man vim sudo
# Install SSH Server
RUN apt-get -y install openssh-server && mkdir -p /var/run/sshd
# Install networking tools
RUN apt-get -y install net-tools dnsutils
# Install postgres
RUN apt-get -y install postgresql
# Install libraries and utilities
#RUN apt-get install -y libwebkitgtk-1.0-0

# Add pentaho user
RUN useradd --create-home -s /bin/bash -G sudo pentaho
RUN sed -i.orig 's/%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/' /etc/sudoers
RUN cp -rvT ~root ~pentaho && chown -R pentaho:pentaho ~pentaho

# Setup Environment
RUN echo export JAVA_HOME=/usr/lib/jvm/java-7-oracle >>/etc/bash.bashrc

# Install startup script
ADD init.sh /
RUN chmod u+x /init.sh

# Start Service
CMD ["/init.sh"]
EXPOSE 22 5432
