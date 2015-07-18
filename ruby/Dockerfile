FROM devbox

# Prerequisites
RUN apt-get update
RUN apt-get -y install autoconf bison libgdbm-dev zlib1g-dev ruby libssl-dev libreadline-dev

# Ruby
ENV RUBY_MAJOR 2.2
ENV RUBY_VERSION 2.2.2
ENV RUBY_DOWNLOAD_SHA256 5ffc0f317e429e6b29d4a98ac521c3ce65481bfd22a8cf845fa02a7b113d9b44

RUN mkdir -p /usr/src/ruby \
    && curl -fSL -o ruby.tar.gz "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.gz" \
    && echo "$RUBY_DOWNLOAD_SHA256 *ruby.tar.gz" | sha256sum -c - \
    && tar -xzf ruby.tar.gz -C /usr/src/ruby --strip-components=1 \
    && rm ruby.tar.gz

RUN cd /usr/src/ruby \
    && autoconf \
    && ./configure --disable-install-doc \
    && make -j"$(nproc)"
RUN cd /usr/src/ruby && make install
RUN apt-get purge -y --auto-remove ruby
RUN rm -rf /usr/src/ruby

USER $DEFAULT_USER

# install things globally
ENV GEM_HOME /home/$DEFAULT_USER/bundle
ENV PATH $GEM_HOME/bin:$PATH
RUN gem install bundler \
    && bundle config --global path "$GEM_HOME" \
    && bundle config --global bin "$GEM_HOME/bin"

# don't create ".bundle" in all our apps
ENV BUNDLE_APP_CONFIG $GEM_HOME

# install config in default user

ENV RUBY_PROFILE /home/$DEFAULT_USER/.profiles/ruby.sh

RUN echo "export GEM_HOME=~/bundle" > $RUBY_PROFILE \
    && echo "export PATH=$GEM_HOME/bin:$PATH" >> $RUBY_PROFILE \
    && echo "export BUNDLE_APP_CONFIG=$GEM_HOME" >> $RUBY_PROFILE

USER root