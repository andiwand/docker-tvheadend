FROM ubuntu:16.04

ARG GIT="https://github.com/tvheadend/tvheadend.git"
ARG TAG="master"
ARG SOURCE_PATH="/usr/src/tvheadend"
ARG HOME_PATH="/config"

RUN apt-get update
RUN apt-get install -y \
        build-essential \
        cmake           \
        pkg-config      \
        python          \
        git
RUN apt-get install -y \
        libssl-dev          \
        libavahi-client-dev \
        zlib1g-dev          \
        libavcodec-dev      \
        libavutil-dev       \
        libavformat-dev     \
        libavresample-dev   \
        libswscale-dev      \
        gettext
RUN apt-get install -y \
        wget    \
        bzip2

RUN git clone "${GIT}" "${SOURCE_PATH}"
RUN cd "${SOURCE_PATH}" \
    && git fetch \
    && git checkout "${TAG}" \
    && ./configure \
        --sysconfdir=/config    \
    && CPU_CORES="$( grep -c processor /proc/cpuinfo )" || CPU_CORES="1" \
    && make -j "${CPU_CORES}" \
    && make install
RUN rm -rf "${SOURCE_PATH}"

VOLUME "${HOME_PATH}"

EXPOSE 9981 9982

CMD "/usr/local/bin/tvheadend"

