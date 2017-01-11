FROM thorgate/alpine-python3.5:1.2.0

# Set maintainer value
MAINTAINER Thorgate, hi@thorgate.eu

# Configure pretenders
WORKDIR /opt/pretenders
ENV PYTHONPATH=/opt/pretenders

COPY requirements/ requirements/

RUN pip3 install -r /opt/pretenders/requirements/runtime.txt

COPY pretenders/ pretenders/

# Copy entrypoint & set command
COPY docker-entrypoint /docker-entrypoint
RUN chmod +x /docker-entrypoint

CMD ["/docker-entrypoint"]
