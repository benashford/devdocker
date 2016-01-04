FROM ubuntu:15.10

# Basics
RUN apt-get -y update && apt-get -y install curl software-properties-common cmake g++ tmux git htop openssh-server

# Default user
ENV DEFAULT_USER ben

RUN useradd $DEFAULT_USER && adduser $DEFAULT_USER sudo && \
    mkdir -p /home/$DEFAULT_USER && \
    chown -R $DEFAULT_USER:$DEFAULT_USER /home/$DEFAULT_USER && \
    chsh -s /bin/bash $DEFAULT_USER

WORKDIR /home/$DEFAULT_USER

RUN mkdir .ssh
COPY authorized_keys .ssh/authorized_keys

# Emacs
RUN apt-get -y install emacs-nox silversearcher-ag

# - Configure
USER $DEFAULT_USER

# Emacs
RUN git clone https://github.com/benashford/.emacs.d.git && \
    emacs --daemon

# Dotfiles
RUN git clone https://github.com/benashford/dotfiles.git && \
    dotfiles/ubuntu/install.sh

USER root

# Tmux

RUN /home/$DEFAULT_USER/dotfiles/ubuntu/install_tmux.sh

# Terminal
ENV TERM xterm-256color

# Project directory
VOLUME /home/$DEFAULT_USER/src

# SSH
EXPOSE 4444

RUN cat /etc/ssh/sshd_config | sed -s "s/Port 22/Port 4444/g" > sshd_new && \
    mv /etc/ssh/sshd_config sshd_old && \
    mv sshd_new /etc/ssh/sshd_config && \
    rm sshd_old

CMD service ssh start && tail -f /var/log/dmesg
