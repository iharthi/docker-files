FROM ubuntu:14.04

# Set maintainer value
MAINTAINER Thorgate, hi@thorgate.eu

# Install python
RUN echo "deb http://ppa.launchpad.net/fkrull/deadsnakes/ubuntu trusty main" > /etc/apt/sources.list.d/deadsnakes.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys DB82666C

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
    build-essential \
    ca-certificates \
    gcc \
    wget \
    git \
    libpq-dev \
    make \
    mercurial \
    pkg-config \
    python3.4 \
    python3.4-dev \
    libffi-dev \
    ssh \
    && apt-get autoremove \
    && apt-get clean

# Install pip
ADD https://raw.githubusercontent.com/pypa/pip/5d927de5cdc7c05b1afbdd78ae0d1b127c04d9d0/contrib/get-pip.py /root/get-pip.py
RUN python3.4 /root/get-pip.py
RUN pip3.4 install -U "setuptools"
RUN pip3.4 install -U "pip"
RUN pip3.4 install -U "virtualenv"

# Generate locales
RUN locale-gen en_US.UTF-8 \
               et_EE \
               et_EE.UTF-8 \
               ru_RU \
               ru_RU.UTF-8

# Set default locale
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:UTF-8
ENV LC_ALL en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive
RUN dpkg-reconfigure -f noninteractive locales

# add extra locales

# install requirements
RUN apt-get update
RUN apt-get install -y libzip-dev libxml2-dev libxslt1-dev curl
RUN apt-get install -y libjpeg62 libjpeg62-dev zlib1g-dev
RUN pip install --upgrade pip
RUN pip install wheel

# Add nodejs rep
RUN apt-get install -y apt-transport-https
RUN curl -sL add https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN echo "deb https://deb.nodesource.com/node_0.12 trusty main" > /etc/apt/sources.list.d/nodesource.list
RUN echo "deb-src https://deb.nodesource.com/node_0.12 trusty main" >> /etc/apt/sources.list.d/nodesource.list
RUN echo "Package: *" > /etc/apt/preferences.d/deb_nodesource_com_node.pref
RUN echo "Pin: release o=Node Source" >> /etc/apt/preferences.d/deb_nodesource_com_node.pref
RUN echo "Pin-Priority: 500" >> /etc/apt/preferences.d/deb_nodesource_com_node.pref
RUN apt-get update

# Also add phantomjs
RUN apt-get install -y \
    libfontconfig1 \
    fonts-dejavu \
    fonts-droid \
    fonts-liberation \
    ttf-ubuntu-font-family \
    nodejs \
    poppler-utils

# Install npm
RUN npm install -g phantomjs-prebuilt

# Copy pip config
COPY common/pip.conf /root/.config/pip/pip.conf

VOLUME /wheelhouse:/wheelhouse
