# Docker container

This directory contains a Dockerfile that can be used to build Docker containers for hardware and software development in Snitch. The Dockerfile uses a multi-stage build, from which two containers can be built: a full-blown hardware development container with all tools required to work with the Snitch repository, and a lightweight software development container that only ships the tools required for software development and includes a prebuilt Verilated model of the Snitch cluster in its default configuration. The software container provides the means to quickly write and simulate software on Snitch. However, if you plan to make any changes to the RTL or the Snitch cluster configuration, you will need to use the HW development container to build a new Verilated model of the Snitch cluster.

## Installation

### Pre-built containers

There are pre-built versions of the containers available online. These versions are up to date with the latest developments on the `main` branch. The CI publishes new containers every time a new commit is pushed to this branch.

To download a container, first login to the GitHub container registry:
```shell
docker login ghcr.io
```
You will be asked for a username (your GitHub username).
As a password you should use a
[personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
that at least has package registry read permission.

You can then install the HW or SW container by running:
```shell
# Hardware container
docker pull ghcr.io/pulp-platform/snitch_cluster-hw:main
# Software container
docker pull ghcr.io/pulp-platform/snitch_cluster-sw:main
```

### Build instructions

In case you cannot use a pre-built container, e.g. if you need to make changes to the Dockerfile, you can build e.g. the container locally by running the following command in the root of the repository:

```shell
docker build -t ghcr.io/pulp-platform/snitch_cluster-sw:main -f util/container/Dockerfile .
```

This will run through the entire multi-stage build, implicitly resulting in the software development container.

You can build the hardware development container by stopping the build at the `snitch_cluster-hw` stage:
```shell
docker build --target snitch_cluster-hw -t ghcr.io/pulp-platform/snitch_cluster-hw:main -f util/container/Dockerfile .
```

## Usage

To run e.g. the hardware container in interactive mode:

```shell
docker run -it --entrypoint /bin/bash -v <path_to_repository_root>:/repo -w /repo ghcr.io/pulp-platform/snitch_cluster-hw:main
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
