FROM thorgate/alpine-python3.5:1.1.1

COPY celery-init.sh /celery-init
RUN chmod +x /celery-init

CMD ["/celery-init"]
