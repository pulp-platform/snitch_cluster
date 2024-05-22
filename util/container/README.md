# Docker container

This directory contains the [Docker file](Dockerfile) used to build the `snitch_cluster` Docker container. The container is based on the Ubuntu 18.04 LTS image and comes with all free development tools for Snitch pre-installed. The environment is also already configured, such that no additional steps are required to work in the container after installation.

## Installation

### Pre-built container

There is a pre-built version of the container available online. This version is up to date with the latest developments on the `main` branch. The CI publishes a new container every time a new commit is pushed to this branch.

To download the container, first login to the GitHub container registry:
```shell
$ docker login ghcr.io
```
You will be asked for a username (your GitHub username).
As a password you should use a
[personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
that at least has package registry read permission.

You can then install the container by running:
```shell
$ docker pull ghcr.io/kuleuven-micas/snax:main
```

### Build instructions

In case you cannot use the pre-built container, e.g. if you need to make changes to the Dockerfile, you can build the
container locally by running the following command in the root of the repository:

```shell
$ sudo docker build -t ghcr.io/kuleuven-micas/snax:main -f util/container/Dockerfile .
```

## Usage

To run the container in interactive mode:

```shell
$ docker run -it -v $REPO_TOP:/repo -w /repo ghcr.io/kuleuven-micas/snax:main
```

## Limitations

Some operations require more memory than the default Docker VM might provide by
default (2 GB on OS X for example). *We recommend at least 16 GB of memory.*

The memory resources can be adjusted in the Docker daemon's settings.

> The swap space is limited to 4 GB in OS X default VM image. It doesn't seem as
> this is enough for using `verilator`, `cc` keeps crashing because it runs out
> of swap space (at least that is what `dmesg` tells us). Also 8 GB of swap
> space don't seem to be enough.
>
> ```shell
> dd if=/dev/zero of=/var/lib/swap bs=1k count=8388608
> chmod go= /var/lib/swap && mkswap /var/lib/swap
> swapon -v /var/lib/swap
> ```
