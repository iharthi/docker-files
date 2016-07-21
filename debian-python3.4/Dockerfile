FROM debian:jessie

# Set maintainer value
MAINTAINER Thorgate, hi@thorgate.eu

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
    build-essential \
    ca-certificates \
    gcc \
    git \
    wget \
    libpq-dev \
    make \
    mercurial \
    pkg-config \
    python3.4 \
    python3.4-dev \
    ssh \
    apt-utils \
    locales \
    && apt-get autoremove \
    && apt-get clean

# Install pip
ADD https://raw.githubusercontent.com/pypa/pip/5d927de5cdc7c05b1afbdd78ae0d1b127c04d9d0/contrib/get-pip.py /root/get-pip.py
RUN python3.4 /root/get-pip.py
RUN pip3.4 install -U "setuptools"
RUN pip3.4 install -U "pip"
RUN pip3.4 install -U "virtualenv"

# Set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
RUN locale-gen --purge en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive
RUN dpkg-reconfigure -f noninteractive locales
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:UTF-8
ENV LC_ALL en_US.UTF-8

# install requirements
RUN apt-get update
RUN apt-get install -y libzip-dev libxml2-dev libxslt1-dev curl
RUN apt-get install -y libjpeg62 libjpeg62-turbo-dev zlib1g-dev
RUN pip install --upgrade pip
RUN pip install wheel

# Add nodejs rep
RUN apt-get install -y apt-transport-https
RUN curl -sL add https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN echo "deb https://deb.nodesource.com/node_0.12 jessie main" > /etc/apt/sources.list.d/nodesource.list
RUN echo "deb-src https://deb.nodesource.com/node_0.12 jessie main" >> /etc/apt/sources.list.d/nodesource.list
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
    nodejs \
    poppler-utils

RUN wget http://mirrors.kernel.org/ubuntu/pool/main/u/ubuntu-font-family-sources/ttf-ubuntu-font-family_0.80-0ubuntu6_all.deb
RUN dpkg -i ttf-ubuntu-font-family*.deb

# Install via npm
RUN npm install -g phantomjs-prebuilt

# Copy pip config
COPY .common/pip.conf /root/.config/pip/pip.conf

VOLUME /wheelhouse:/wheelhouse
