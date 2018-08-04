FROM tiagosr/cross-compiler-base-auto:latest

ENV N64_INST=/usr/local

COPY ./tools/build /tmp/tools/build
WORKDIR /tmp/tools
RUN JOBS=8 ./build && rm -rf /tmp/tools

COPY . /libdragon/
WORKDIR /libdragon

RUN make --jobs 8 && make install && make --jobs 8 tools && make tools-install && rm -rf /libdragon/* && git clone https://github.com/networkfusion/libmikmod.git /tmp/libmikmod && cd /tmp/libmikmod/n64 && make --jobs 8 && make install && rm -rf /tmp/libmikmod

CMD /bin/bash