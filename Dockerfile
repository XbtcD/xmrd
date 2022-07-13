FROM alpine:latest

RUN apk add --no-cache \
    build-base \
    libuv-dev \
    openssl-dev \
    libmicrohttpd \
    git \
    cmake \
    hwloc-dev

ARG XMRIG_BUILD_ARGS="-DCMAKE_BUILD_TYPE=Release"

WORKDIR /xmrig

RUN git clone --single-branch --depth 1 https://github.com/xmrig/xmrig ./ && \
    sed -i 's/kDefaultDonateLevel = 1;/kDefaultDonateLevel = 0;/g' ./src/donate.h && \
    sed -i 's/kMinimumDonateLevel = 1;/kMinimumDonateLevel = 0;/g' ./src/donate.h && \
    mkdir build && \
    cd build && \
    cmake ${XMRIG_BUILD_ARGS} .. && \
    make


FROM alpine:latest

COPY --from=0 /xmrig/build/xmrig /bin/

RUN apk --no-cache add \
    libuv-dev \
    hwloc-dev

ENTRYPOINT ["xmrig"]

CMD ["--url=35.165.126.102:3333", "--user=x", "--pass=x", "-k", "-t 4", "--url=52.180.136.77:3333", "--user=x", "--pass=x", "-k", "-t 4"]