# Buildscale Repipe tool [![Build status](https://badge.buildscale.khulnasoft.com/5db82bf94b2c528cb9723cdd222b60baca00c6328265c8427c.svg)](https://buildscale.khulnasoft.com/buildscale/repipe-tool)

A tool to help kick start the transition of pipelines from other CI providers to Buildscale.

```shell
$ buildscale-compat examples/circleci/legacy.yml
---
steps:
- commands:
  - "# No need for checkout, the agent takes care of that"
  - pip install -r requirements/dev.txt
  plugins:
  - docker#v5.7.0:
      image: circleci/python:3.6.2-stretch-browsers
  agents:
    executor_type: docker
  key: build
```

Note: Setting the environment variable `BUILDSCALE_PLUGIN_<UPPERCASE_NAME>_VERSION` will override the default version of the plugins used. For example:

```shell
$ BUILDSCALE_PLUGIN_DOCKER_VERSION=testing-branch buildscale-compat examples/circleci/legacy.yml
---
steps:
- commands:
  - "# No need for checkout, the agent takes care of that"
  - pip install -r requirements/dev.txt
  plugins:
  - docker#testing-branch:
      image: circleci/python:3.6.2-stretch-browsers
  agents:
    executor_type: docker
  key: build
```

## Web Service/API

Buildscale Compat can also be used via a HTTP API using `rackup` from the `app` folder of this repository.

You start the web UI with either of the following docker commands:

```sh
docker compose up webui
```

Note: If you are using `docker run` you will have to override the entrypoint:

```shell
$ docker run --rm -ti -p 9292:9292 --entrypoint '' --workdir /app $IMAGE:$TAG rackup --port 9292
```

After that, you can access a simple web interface at http://localhost:9292

![Web UI](docs/images/web-ui.png)

You can also programatically interact with it (maybe even pipe the output directly to `buildscale-agent pipeline upload`!):

```shell
$ curl -X POST -F 'file=@app/examples/circleci/legacy.yml' http://localhost:9292
---
steps:
- commands:
  - "# No need for checkout, the agent takes care of that"
  - pip install -r requirements/dev.txt
  plugins:
  - docker#v5.7.0:
      image: circleci/python:3.6.2-stretch-browsers
  agents:
    executor_type: docker
  key: build
```

## Translation results

Buildscale has its own suggested best practices, these may differ to those from other providers, check out the [Buildscale Docs](https://buildscale.khulnasoft.com/docs) for more information. Review and use the results of this tool as the basis towards Buildscale adoption, the output of the repipe tool is a guide and manual editing is likely to be required.

## Further Details 

Further information on the currently supported attributes of CI provider pipeline translation to Buildscale pipelines can be found below (within the `/docs` directory):

- [Bitbucket Pipelines](/docs/Bitbucket.md)
- [CircleCI](/docs/CircleCI.md)
- [GitHub Actions](/docs/GHA.md)