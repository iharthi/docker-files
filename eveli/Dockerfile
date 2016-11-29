# Dockerfile for Docker-Eveli event listener

FROM python:3.5.2-slim

MAINTAINER Thorgate, hi@thorgate.eu

COPY ./requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

COPY ./Eveli.py /usr/bin/Eveli.py

CMD python /usr/bin/Eveli.py
