FROM python:3.6.1

MAINTAINER Thorgate, hi@thorgate.eu

RUN apt-get update \
    && apt-get install -y  \
        apt-transport-https \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sL add https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN echo "deb http://deb.nodesource.com/node_6.x jessie main" > /etc/apt/sources.list.d/nodesource.list
RUN echo "deb-src http://deb.nodesource.com/node_6.x jessie main" >> /etc/apt/sources.list.d/nodesource.list
RUN echo "Package: *" > /etc/apt/preferences.d/deb_nodesource_com_node.pref
RUN echo "Pin: release o=Node Source" >> /etc/apt/preferences.d/deb_nodesource_com_node.pref
RUN echo "Pin-Priority: 500" >> /etc/apt/preferences.d/deb_nodesource_com_node.pref

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y  \
    build-essential \
    ca-certificates \
    gcc \
    gettext \
    git \
    libffi-dev \
    libpq-dev \
    locales \
    make \
    mercurial \
    nodejs \
    pkg-config \
    ssh \
    wget \
    libzip-dev libxml2-dev libxslt1-dev curl \
    libjpeg62 libjpeg62-turbo-dev zlib1g-dev \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
RUN sed -i -e 's/# et_EE UTF-8/et_EE UTF-8/' /etc/locale.gen
RUN sed -i -e 's/# et_EE.UTF-8 UTF-8/et_EE.UTF-8 UTF-8/' /etc/locale.gen
RUN sed -i -e 's/# ru_RU UTF-8/ru_RU UTF-8/' /etc/locale.gen
RUN sed -i -e 's/# ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen
RUN locale-gen --purge en_US.UTF-8 et_EE et_EE.UTF-8 ru_RU ru_RU.UTF-8
ENV DEBIAN_FRONTEND noninteractive
RUN dpkg-reconfigure -f noninteractive locales
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:UTF-8
ENV LC_ALL en_US.UTF-8

# install requirements
RUN pip install --upgrade pip
RUN pip install --upgrade wheel
RUN pip install --upgrade setuptools
RUN pip install --upgrade virtualenv

# Copy pip config
RUN ls -la
COPY .common/pip.conf /root/.config/pip/pip.conf

VOLUME /wheelhouse
