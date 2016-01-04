# Based on micktwomey/python3.4
FROM micktwomey/python3.4

# Set maintainer value
MAINTAINER Thorgate, hi@thorgate.eu

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive
RUN dpkg-reconfigure -f noninteractive locales

# install requirements
RUN apt-get update
RUN apt-get install -y libzip-dev libxml2-dev libxslt1-dev curl
RUN pip install wheel

# Add nodejs rep
RUN curl -sL https://deb.nodesource.com/setup_0.12 | sudo bash -

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
RUN npm install -g phantomjs

# Copy pip config
COPY pip.conf /root/.config/pip/pip.conf

VOLUME /wheelhouse:/wheelhouse
