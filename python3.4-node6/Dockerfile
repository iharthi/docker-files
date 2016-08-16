FROM thorgate/python3.4

MAINTAINER Thorgate, hi@thorgate.eu

RUN echo "deb https://deb.nodesource.com/node_6.x trusty main" > /etc/apt/sources.list.d/nodesource.list
RUN echo "deb-src https://deb.nodesource.com/node_6.x trusty main" >> /etc/apt/sources.list.d/nodesource.list
RUN apt-get update
RUN apt-get install nodejs
