FROM ubuntu:15.04

RUN apt-get -y update

# Basics
RUN apt-get -y install openssh-server
RUN apt-get -y install git emacs24-nox

RUN apt-get -y install htop

# Terminal
ENV TERM xterm-256color

# Default user
ENV DEFAULT_USER ben

RUN useradd $DEFAULT_USER && adduser $DEFAULT_USER sudo
RUN mkdir -p /home/$DEFAULT_USER
RUN chown -R $DEFAULT_USER:$DEFAULT_USER /home/$DEFAULT_USER
RUN chsh -s /bin/bash $DEFAULT_USER

WORKDIR /home/$DEFAULT_USER

USER $DEFAULT_USER

RUN mkdir .ssh
COPY authorized_keys .ssh/authorized_keys

RUN git clone https://github.com/benashford/dotfiles.git
RUN dotfiles/install.sh

RUN git clone https://github.com/benashford/.emacs.d.git

RUN emacs --daemon

USER root

VOLUME /home/$DEFAULT_USER/src

# Tmux
RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:p-pisati/misc
RUN apt-get -y update
RUN apt-get -y install tmux tmux-mem-cpu-load

# SSH
EXPOSE 4444

RUN cat /etc/ssh/sshd_config | sed -s "s/Port 22/Port 4444/g" > sshd_new
RUN mv /etc/ssh/sshd_config sshd_old
RUN mv sshd_new /etc/ssh/sshd_config

CMD service ssh start && tail -f /var/log/dmesg
