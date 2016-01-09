FROM devbox

RUN curl -L https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda3-2.4.1-Linux-x86_64.sh > /tmp/Anaconda3-2.4.1-Linux-x86_64.sh && \
    yes yes | bash /tmp/Anaconda3-2.4.1-Linux-x86_64.sh && \
    rm -rf /tmp/Anaconda3-2.4.1-Linux-x86_64.sh && \
    echo "export PATH=/home/$DEFAULT_USER/yes/bin:$PATH" > /home/$DEFAULT_USER/.profiles/anaconda.sh && \
    chown -R $DEFAULT_USER:$DEFAULT_USER /home/$DEFAULT_USER/yes

ENV PATH=/home/$DEFAULT_USER/yes/bin:$PATH
