# 
# Thanks to Adam Miller <maxamillion@fedoraproject.org> from
#   https://github.com/fedora-cloud/Fedora-Dockerfiles
# 
FROM centos:centos7
MAINTAINER blakeberg <bjoern.lakeberg@technik-emden.de>

ENV SSH_USERPASS=newpass

RUN curl --silent --location https://rpm.nodesource.com/setup_4.x | bash -

RUN yum -y update; yum clean all
RUN yum -y install openssh-server passwd sudo nodejs; yum clean all

RUN mkdir /var/run/sshd
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' 

RUN useradd -m meteor
RUN echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin meteor)
RUN echo ssh meteor password: $SSH_USERPASS
RUN bash -c 'echo "meteor ALL=(ALL:ALL) ALL" | (EDITOR="tee -a" visudo)'

RUN curl https://install.meteor.com/ | sh
RUN npm install -g meteor-build-client

EXPOSE 22 3000
ENTRYPOINT ["/usr/sbin/sshd", "-D"]
