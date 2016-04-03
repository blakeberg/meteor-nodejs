# 
# Thanks to Adam Miller <maxamillion@fedoraproject.org> from
#   https://github.com/fedora-cloud/Fedora-Dockerfiles
# 
FROM centos:centos7
MAINTAINER blakeberg <bjoern.lakeberg@technik-emden.de>

ENV SSH_USERPASS=newpass

RUN curl --silent --location https://rpm.nodesource.com/setup_4.x | bash -

RUN yum -y update; yum clean all
RUN yum -y install openssh-server passwd sudo nodejs git; yum clean all

RUN useradd -m meteor
RUN echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin meteor)
RUN echo ssh meteor password: $SSH_USERPASS
RUN bash -c 'echo "meteor ALL=(ALL:ALL) ALL" | (EDITOR="tee -a" visudo)'
ADD dummy-dapp-example/* /home/meteor/

RUN mkdir /var/run/sshd
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' 

RUN curl https://install.meteor.com/ | sh
RUN npm install -g meteor-build-client
RUN npm install solc
RUN npm install web3

EXPOSE 22 3000
ENTRYPOINT ["/usr/sbin/sshd", "-D"]
