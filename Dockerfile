FROM ubuntu:15.04

RUN apt-get -y update

RUN apt-get -y install openssh-server
RUN apt-get -y install git emacs24-nox

ENV TERM xterm-256color

RUN useradd ben && adduser ben sudo
RUN mkdir -p /home/ben
RUN chown -R ben:ben /home/ben
RUN chsh -s /bin/bash ben

WORKDIR /home/ben

USER ben

RUN mkdir .ssh
COPY authorized_keys .ssh/authorized_keys

RUN git clone https://github.com/benashford/dotfiles.git
RUN dotfiles/install.sh

RUN git clone https://github.com/benashford/.emacs.d.git

RUN emacs --daemon

USER root

EXPOSE 4444

RUN cat /etc/ssh/sshd_config | sed -s "s/Port 22/Port 4444/g" > sshd_new
RUN mv /etc/ssh/sshd_config sshd_old
RUN mv sshd_new /etc/ssh/sshd_config

CMD service ssh start && tail -f /var/log/dmesg