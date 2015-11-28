FROM ubuntu:15.10

# Tmux
RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:p-pisati/misc
RUN apt-get -y update
RUN apt-get -y install tmux tmux-mem-cpu-load

# Basics
RUN apt-get -y install git build-essential
RUN apt-get -y install htop openssh-server

# Utils
RUN apt-get -y install curl silversearcher-ag

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
# - Install
ENV EMACS_VERSION 24.5
ENV EMACS_DOWNLOAD_SHA256 dd47d71dd2a526cf6b47cb49af793ec2e26af69a0951cc40e43ae290eacfc34e

RUN mkdir -p /usr/src/emacs \
    && curl -fSL -o emacs.tar.xz "http://ftp.gnu.org/gnu/emacs/emacs-$EMACS_VERSION.tar.xz" \
    && echo "$EMACS_DOWNLOAD_SHA256 *emacs.tar.xz" | sha256sum -c - \
    && tar -xf emacs.tar.xz -C /usr/src/emacs --strip-components=1 \
    && rm emacs.tar.xz

RUN apt-get -y install libncurses-dev

RUN cd /usr/src/emacs \
    && ./configure \
    && make
RUN cd /usr/src/emacs && make install

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
