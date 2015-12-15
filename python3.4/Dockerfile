FROM micktwomey/python3.4
MAINTAINER Thorgate, hi@thorgate.eu

RUN apt-get update
RUN apt-get install -y libzip-dev libxml2-dev libxslt1-dev
RUN pip install wheel

COPY pip.conf /root/.config/pip/pip.conf

VOLUME /wheelhouse:/wheelhouse
