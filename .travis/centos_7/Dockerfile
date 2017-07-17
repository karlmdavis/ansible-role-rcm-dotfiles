FROM centos:7
ENV container docker

# Ensure that systemd doesn't start a bunch of things that it shouldn't.
# Reference: https://hub.docker.com/_/centos/
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

# Install and start SSH.
RUN yum update -y
RUN yum install -y openssh-server sudo
RUN /usr/bin/systemctl enable sshd

# Create the SSH user.
RUN useradd ansible_test -G wheel
RUN echo 'ansible_test:secret' | chpasswd
RUN echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

VOLUME [ "/sys/fs/cgroup" ]
EXPOSE 22
CMD ["/usr/sbin/init"]

