FROM python:3.5-alpine

# Set maintainer value
MAINTAINER Thorgate, hi@thorgate.eu

RUN \
    echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && apk upgrade && \
    apk add \
        alpine-sdk \
        wget \
        postgresql-dev \
        mercurial \
        libffi-dev \
        libxml2-dev \
        libxslt-dev \
        libjpeg-turbo \
        libjpeg-turbo-dev \
        zlib-dev \
        libpng-dev \
        fontconfig \
        ttf-dejavu \
        ttf-droid-nonlatin \
        ttf-liberation \
        ttf-ubuntu-font-family \
        poppler-utils \
        libzip-dev@testing \
        nodejs-lts && \
    npm install -g phantomjs-prebuilt && \
    pip install --upgrade virtualenv pip


# Copy pip config
COPY .common/pip.conf /root/.config/pip/pip.conf

# Use global wheelhouse /dir
VOLUME /wheelhouse:/wheelhouse
