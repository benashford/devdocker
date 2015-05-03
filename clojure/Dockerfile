FROM devbox-java

RUN apt-get update
RUN apt-get install -y curl

RUN curl https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein > /usr/local/bin/lein
RUN chmod +x /usr/local/bin/lein

USER $DEFAULT_USER

RUN lein

USER $DEFAULT_USER

RUN cd dotfiles && git pull && cd ..
RUN cp -R dotfiles/.lein/* .lein

USER root