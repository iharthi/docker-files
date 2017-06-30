import json
import logging.config
import subprocess

from docker import Client


logging.config.dictConfig({
    'version': 1,
    'formatters': {
        'default': {
            'format': '%(asctime)s [%(levelname)s] %(name)s:%(lineno)d %(funcName)s - %(message)s'
        },
    },
    'handlers': {
        'log': {
            'class': 'logging.handlers.WatchedFileHandler',
            'filename': '/var/log/docker-eveli/info.log',
            'formatter': 'default',
        },
    },
    'loggers': {
        '': {
            'handlers': ['log'],
            'level': 'INFO',
        }
    }
})


def handler_nginx_reload(cli, event):
    """ Sends reload signal to nginx whenever a container's IP might have changed
    """

    reload_actions = ["start", "stop", "pause", "unpause", "kill"]
    required_keys = ["Type", "Action", "from"]

    if not all(k in event for k in required_keys) or event['Action'] not in reload_actions:
        return

    logging.info("handler_nginx_reload() %s %s %s", event['Action'], event['Type'], event['from'])
    exe = cli.exec_create(container='nginx', cmd='nginx -s reload')
    exec_start = cli.exec_start(exec_id=exe)
    inspect = cli.exec_inspect(exec_id=exe)
    if 'ExitCode' in inspect and inspect['ExitCode'] != 0:
        raise RuntimeError(exec_start)


def listen():
    logging.info("Eveli is alive!")

    cli = Client(base_url='unix:///var/run/docker.sock')

    event_handlers = [handler_nginx_reload]

    for event in cli.events():
        event = json.loads(event.decode('utf-8'))
        for handler in event_handlers:
            try:
                handler(cli, event)
            except:
                logging.exception("Event handler %s failed", handler.__name__)


if __name__ == "__main__":
    listen()
