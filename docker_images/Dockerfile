# name jacarte/slumps:backend
FROM jacarte/slumps:souper as builder
# souper:deps
env DEBIAN_FRONTEND=noninteractive

RUN echo "Installing packages"

RUN apt-get update \
    && apt-get -y install tree  cmake re2c doxygen golang-go python python3 llvm git subversion curl build-essential gcc-multilib redis-server \
    && go get github.com/gomodule/redigo/redis && rm -rf /var/lib/apt/lists/*

RUN mkdir slumps
WORKDIR slumps

# Rebuild on KTH repo update

RUN git clone https://github.com/WebAssembly/wabt

RUN cd wabt \
    && git submodule update --init \
    && mkdir build && cd build \
    && cmake .. \
    && cmake --build . 

run git clone https://github.com/WebAssembly/wasi-libc \
    && cd wasi-libc \
    && make install INSTALL_DIR=/tmp/wasi-libc

FROM ubuntu:20.04

RUN apt-get update \
    && apt-get -y install tree 
    
WORKDIR slumps

COPY --from=builder /slumps/wabt/build/wasm2wat /slumps/wabt/build/wasm2wat
COPY --from=builder /usr/src/souper-build /slumps/souper/build
COPY --from=builder /usr/src/souper/third_party /slumps/souper/third_party
COPY --from=builder /tmp/wasi-libc /tmp/wasi-libc

RUN rm -rf /slumps/souper/build/CMakeFiles && rm -rf /slumps/souper/build/docs && rm -rf /slumps/souper/build/CMakeCache.txt && rm -rf /slumps/souper/build/build.ninja
RUN tree /slumps