FROM ubuntu:18.04

MAINTAINER Ashvin Kumaran <ashvinrobot360@gmail.com>

RUN apt-get update

# setup ssh keys and ssh client config
WORKDIR /root
COPY ssh.tar .
RUN echo $HOME
RUN tar -xvf ssh.tar -C $HOME
RUN chown -R root:root $HOME/.ssh

# install all required dependent packages to run fio
RUN apt-get install -y libaio-dev libaio1 \
	libc6 \
	libibverbs-dev \
	librdmacm1 \
	python \
	zlib1g \
 	wget \
	gcc \
    make \
	openssh-client \
    netcat-openbsd \
    iproute2 \
    jq

# Download fio-3.18 source, build and install
RUN wget https://github.com/axboe/fio/archive/fio-3.18.tar.gz && \
    tar xvzf fio-3.18.tar.gz && \
    cd fio-fio-3.18 && \
    ./configure && \
    make install

# copy wrapper shell script to run fio on remote server
WORKDIR /root
RUN mkdir $HOME/perf
COPY ./perf_run_remote.sh ./perf

# RUN ./fio_run_remote.sh 192.168.0.17 /dev/sdb block read 90 10

WORKDIR /root
CMD ["echo", "Docker is Prepared to run FIO!"]
