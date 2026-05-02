FROM ghcr.io/open-education-hub/vmcheker-next-base-image/base-container:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -yqq && \
    apt-get install -yqq build-essential gcc-multilib nasm python3 bc

COPY ./checker ${CHECKER_DATA_DIRECTORY}