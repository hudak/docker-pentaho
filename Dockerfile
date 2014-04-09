#Dockerfile
FROM dockerfile/java
MAINTAINER Nick Hudak nhudak@pentaho.com

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN apt-get update
RUN apt-get -y upgrade

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
RUN cp -rvT /root /home/pentaho
RUN chown -Rv pentaho:pentaho /home/pentaho

# Setup Environment
RUN echo export JAVA_HOME=/usr/lib/jvm/java-7-oracle >>/etc/bash.bashrc

# Install startup script
ADD init.sh /root/
RUN chmod u+x /root/init.sh

# Start Service
CMD ["/root/init.sh"]
EXPOSE 22 5432
