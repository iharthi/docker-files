import json
import logging.config

import requests
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


def get_image_name(container_from):
    """ Extracts the image name (without tag) from container's 'from' field. """
    return container_from.rsplit(':', 1)[0]


def get_compose_projects(cli):
    """ Returns list of names of active Docker Compose projects
    """
    projects = set()
    for container in cli.containers():
        labels = container['Labels']
        project = labels.get('com.docker.compose.project')
        if project:
            projects.add(project)

    return projects


def try_connect_container_to_network(cli, container, network):
    try:
        cli.connect_container_to_network(container, network)
    except requests.exceptions.HTTPError:
        pass


def ensure_networks(cli):
    projects = get_compose_projects(cli)
    logging.info("ensure_networks(): docker-compose projects found: %s", projects)

    for project in projects:
        try_connect_container_to_network(cli, 'nginx', project + '_nginx')
        try_connect_container_to_network(cli, 'postgres-9.5', project + '_postgres')


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


def handler_compose_networks(cli, event):
    """ Ensures that nginx and postgres are in corresponding networks of each docker-compose project

    They need to be re-added e.g. when nginx/postgres containers are restarted.
    """

    required_keys = ["Type", "Action", "from"]
    actions = ["start", "unpause"]
    image_names = ['nginx', 'postgres']

    if not all(k in event for k in required_keys) or event['Action'] not in actions:
        return
    if get_image_name(event['from']) not in image_names:
        return

    logging.info("handler_compose_networks() %s %s %s", event['Action'], event['Type'], event['from'])
    ensure_networks(cli)


def listen():
    logging.info("Eveli is alive!")

    cli = Client(base_url='unix:///var/run/docker.sock')

    # Just in case, run the networks-fixer at startup as well
    ensure_networks(cli)

    # Could use decorators to register the event handlers when we get more of them
    event_handlers = [handler_nginx_reload, handler_compose_networks]

    for event in cli.events():
        event = json.loads(event.decode('utf-8'))
        for handler in event_handlers:
            try:
                handler(cli, event)
            except:
                logging.exception("Event handler %s failed", handler.__name__)


if __name__ == "__main__":
    listen()
