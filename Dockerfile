FROM ubuntu:15.10

# Basics
RUN apt-get -y update && apt-get -y install curl software-properties-common tmux git htop openssh-server

# tmux-mem-cpu-load
RUN apt-get --fix-missing -y install build-essential cmake
RUN mkdir -p /usr/src/tmux-mem-cpu-load && \
    cd /usr/src/tmux-mem-cpu-load && \
    git clone --depth=1 https://github.com/thewtex/tmux-mem-cpu-load.git . && \
    cmake . && \
    make && \
    make install && \
    cd / && \
    rm -rf /usr/src/tmux-mem-cpu-load

# tmux
RUN apt-get -y install libevent-dev libncurses5-dev
RUN mkdir -p /usr/src/tmux && \
    cd /usr/src/tmux && \
    curl -L https://github.com/tmux/tmux/releases/download/2.1/tmux-2.1.tar.gz > tmux-2.1.tar.gz && \
    tar zxvf tmux-2.1.tar.gz && \
    cd tmux-2.1 && \
    ./configure && make && \
    make install && \
    cd / && \
    rm -rf /usr/src/tmux

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

RUN git clone https://github.com/benashford/.emacs.d.git && \
    emacs --daemon

# Dotfiles
RUN git clone https://github.com/benashford/dotfiles.git && \
    dotfiles/install.sh

USER root

# Project directory
VOLUME /home/$DEFAULT_USER/src

# SSH
EXPOSE 4444

RUN cat /etc/ssh/sshd_config | sed -s "s/Port 22/Port 4444/g" > sshd_new && \
    mv /etc/ssh/sshd_config sshd_old && \
    mv sshd_new /etc/ssh/sshd_config && \
    rm sshd_old

CMD service ssh start && tail -f /var/log/dmesg
