FROM ubuntu:15.10

RUN apt-get -y update

# Basics
RUN apt-get -y install software-properties-common tmux git htop openssh-server

# tmux-mem-cpu-load
RUN apt-get -y install build-essential cmake
RUN mkdir -p /usr/src/tmux-mem-cpu-load && \
    cd /usr/src/tmux-mem-cpu-load && \
    git clone https://github.com/thewtex/tmux-mem-cpu-load.git . && \
    cmake . && \
    make && \
    make install

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

USER root

# Emacs
RUN apt-get -y install emacs-nox silversearcher-ag

# - Configure
USER $DEFAULT_USER

RUN git clone https://github.com/benashford/.emacs.d.git
RUN emacs --daemon

# Dotfiles
RUN git clone https://github.com/benashford/dotfiles.git
RUN dotfiles/install.sh

USER root

# Project directory
VOLUME /home/$DEFAULT_USER/src

# SSH
EXPOSE 4444

RUN cat /etc/ssh/sshd_config | sed -s "s/Port 22/Port 4444/g" > sshd_new
RUN mv /etc/ssh/sshd_config sshd_old
RUN mv sshd_new /etc/ssh/sshd_config
RUN rm sshd_old

CMD service ssh start && tail -f /var/log/dmesg
