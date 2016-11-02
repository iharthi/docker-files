FROM thorgate/alpine-python3.5:1.2.0

COPY celery-init.sh /celery-init
RUN chmod +x /celery-init

CMD ["/celery-init"]
