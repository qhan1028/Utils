#!/bin/bash

USER_LOCAL_BIN=$HOME/.local/bin
[ ! -d ${USER_LOCAL_BIN} ] && mkdir -p ${USER_LOCAL_BIN}

FFMPEG_VERSION="6.0"
EXT=".zip"

for package in ffmpeg ffprobe; do
  FILE=${package}-${FFMPEG_VERSION}${EXT}
  BIN=${package}

  curl https://evermeet.cx/ffmpeg/${FILE} --output ${FILE}
  unzip -o ${FILE}
  mv ${BIN} ${USER_LOCAL_BIN}
  unlink ${FILE}

  echo -e $(tput setaf 2)Install ${package} success! $(tput sgr0)
done
