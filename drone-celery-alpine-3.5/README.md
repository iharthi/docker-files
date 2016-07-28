# drone celery container

This container provides a way to run celery in a separate service container
with drone.

In most cases, CELERY_ALWAYS_EAGER is enough when testing. But if you still need
to run a separate celery instance (for whatever reason) in drone then this
container will help you.

Warning: This container is based on `alpine linux` and `python3.5`. This means
that everything you execute inside celery does not share builtin binaries with the
main test container (unless it also uses the same base).

## Usage

1. Add the following to `.drone.yml` compose block

```
compose:
  celery:
    image: thorgate/drone-celery-alpine-3.5
    environment:
      - DRONE_PROJECT_PATH=github.com/foo/bar
      - CELERY_APP=bar
```

2. Add extra environment variable definitions based on the project structure
3. If the project needs to wait for something before launching celery
   (for example installing dependencies), add the following command into
   the test pipeline in `.drone.yml`:

    # Let celery container know it is allowed to start
    - touch .celery-ready

  See `CELERY_RUN_ASAP` if you dont need to wait

4. that should be it

## Env variables

### CELERY_APP

App name to give celery binary

### DRONE_PROJECT_PATH

Set this to value to the directory drone assigns to your project, drone currently
uses the following format:

```
remote/owner/repo
```

for example:

```
github.com/thorgate/docker-files
```

### CELERY_RUN_ASAP

This setting can be used to skip waiting for `.celery-ready` file

### CELERY_INNER_DIR

Set this if celery needs to be executed from a subdir of project root

### VENV_PATH

If your project is using virtualenv then use this to specify where it is.

### CELERY_LOG_FILE

Since service containers are executed in the background, this log file variable
can be used in combination with volumes to figure out what goes wrong
