FROM devbox-jupyter

RUN add-apt-repository -y ppa:staticfloat/juliareleases && \
    apt-get update && \
    apt-get install -y julia

USER $DEFAULT_USER

RUN julia -e "Pkg.update()" && \
    julia -e "Pkg.add(\"IJulia\")" && \
    julia -e "Pkg.build()"

USER root
