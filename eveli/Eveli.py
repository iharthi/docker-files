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

def listen():
    logging.info("Eveli is alive!")

    reload_actions = ["start", "stop", "pause", "unpause", "kill"]
    required_keys = ["Type", "Action", "from"]

    cli = Client(base_url='unix:///var/run/docker.sock')

    for event in cli.events():
        event = json.loads(event.decode('utf-8'))
        if all (k in event for k in required_keys) and event['Action'] in reload_actions:
            logging.info("{action} {type} {container}".format(action=event['Action'], type=event['Type'], container=event['from']))
            try:
                exe = cli.exec_create(container='nginx', cmd='nginx -s reload')
                exec_start = cli.exec_start(exec_id=exe)
                inspect = cli.exec_inspect(exec_id=exe)
                if 'ExitCode' in inspect and inspect['ExitCode'] != 0:
                    raise RuntimeError(exec_start)
            except Exception as e:
                logging.exception("Failed to reload nginx!")


if __name__ == "__main__":
    listen()
