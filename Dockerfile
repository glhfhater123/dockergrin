FROM ubuntu:16.04
LABEL maintainer "no"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y git fasm gcc g++ build-essential cmake libboost-all-dev \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean -y

WORKDIR /tmp

RUN git clone https://github.com/veruscoin/nheqminer.git \
  && cd nheqminer/cpu_xenoncat/asm_linux/ \
  && sh assemble.sh \
  && cd ../../../ \
  && mkdir build \
  && cd build \
  && cmake ../nheqminer \
  && make -j$(nproc) \
  && cp ./nheqminer /usr/local/bin/nheqminer \
  && chmod +x /usr/local/bin/nheqminer

RUN useradd -ms /bin/bash nheqminer
USER nheqminer

WORKDIR /home/nheqminer
ENTRYPOINT ["/usr/local/bin/nheqminer"]
CMD ["-h"]
