# r2docker
# ========
#
# Build docker image with:
# $ docker build -t r2docker:1.3.0 .
#
# Run the docker image:
# $ docker images
# $ export DOCKER_IMAGE_ID=$(docker images --format '{{.ID}}' -f 'label=r2docker')
# $ docker run -ti r2docker:1.3.0
#
# Once you quit the bash session get the container id with:
# $ docker ps -a | grep bash
#
# To get into that shell again just type:
# $ docker start -ai <containedid>
#
# To share those images:
# $ docker export <containerid> | xz > container.xz
# $ xz -d < container.xz | docker import -
#
#
# If you willing to debug a program within Docker, you should run it in privileged mode:
#
# $ docker run -it --cap-add=SYS_PTRACE --cap-drop=ALL radare/radare2
# $ r2 -d /bin/true
#
FROM debian:8

LABEL r2docker 1.3.0

# Radare version
ENV R2_VERSION 1.3.0
# R2pipe python version
ENV R2_PIPE_PY_VERSION 0.8.9
# R2pipe node version
ENV R2_PIPE_NPM_VERSION 2.3.2

# Build radare2 in a volume to minimize space used by build
VOLUME ["/src"]
# Install docker in only one layer to minimize space
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
     apt-get install -y \
     curl \
     gcc \
     git \
     bison \
     pkg-config \
     make \
     glib-2.0 \
     sudo && \
     curl -sL https://deb.nodesource.com/setup_7.x | bash - && \
     apt-get install -y nodejs python-pip && \
     curl -sL https://www.npmjs.com/install.sh | bash - && \
     pip install r2pipe=="$R2_PIPE_PY_VERSION" && \
     npm install -g "r2pipe@$R2_PIPE_NPM_VERSION" && \
     cd /src && \
     git clone -b "$R2_VERSION" --depth 1 https://github.com/radare/radare2.git && \
     cd radare2 && \
     ./sys/install.sh && \
     make install && \
     apt-get remove --purge -y \
     curl \
     gcc \
     git \
     bison \
     pkg-config \
     make \
     python-pip \
     glib-2.0 && \
     apt-get autoremove --purge -y && \
     apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /src
ENV HOME /src

CMD ["/bin/bash"]
