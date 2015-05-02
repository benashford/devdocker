FROM devbox

RUN echo echo-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections

RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update

RUN apt-get install -y oracle-java8-installer

RUN rm -rf /var/lib/apt/lists/* # && /var/cache/oracle-jdk8-installer

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

ENV JAVA_PROFILE /home/$DEFAULT_USER/.profiles/java.sh

RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle" > $JAVA_PROFILE