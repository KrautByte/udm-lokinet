FROM debian:latest
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install build-essential cmake git libcap-dev pkg-config automake libtool libuv1-dev libsodium-dev libzmq3-dev libcurl4-openssl-dev libevent-dev nettle-dev libunbound-dev libsqlite3-dev libssl-dev libcap2-bin -y
RUN git clone --recursive https://github.com/oxen-io/lokinet
WORKDIR lokinet
RUN mkdir build
WORKDIR build
RUN cmake .. -DBUILD_STATIC_DEPS=OFF -DBUILD_SHARED_LIBS=ON -DSTATIC_LINK=OFF
RUN make -j$(nproc)
WORKDIR daemon
RUN chmod +x lokinet lokinet-bootstrap lokinet-vpn
RUN mkdir /var/lib/lokinet
RUN ./lokinet-bootstrap
RUN echo "#!/bin/bash \necho 'nameserver 127.3.2.1' > /etc/resolv.conf; ./lokinet" > start.sh
RUN chmod +x start.sh

ENTRYPOINT ["./start.sh"]