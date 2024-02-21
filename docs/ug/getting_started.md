<!--start-section-1-->

# Getting Started

## Installation

Clone the repository:
```shell
git clone https://github.com/pulp-platform/{{ repo  }}.git --recurse-submodules
```

If you had already cloned the repository without the `--recurse-submodules` flag, clone its submodules:
```shell
git submodule update --init --recursive
```

## Tools and environment

This repository requires several tools to be installed on your machine. Some of these tools require non-free licenses. However, most of the functionality in this repository can be reproduced with free tools alone.

Note that installing all tools, in appropriate versions, may be non-trivial. For this purpose, we provide a Docker container with all free tools installed.

The [following section](https://pulp-platform.github.io/{{ repo }}/ug/getting_started.html#docker-container) provides instructions to install the Docker container.

Users with access to ETH Zurich IIS machines can find all tools already installed on these machines. To complete the setup, skip to the [IIS environment setup](https://pulp-platform.github.io/{{ repo }}/ug/getting_started.html#iis-environment-setup) section.

If you do choose to setup a custom development environment on your own machine, we strongly recommend you take example from our [Docker file](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/util/container/README.md).

## Docker container

<!--end-section-1-->

The following instructions are extracted from the Docker container [README.md](https://github.com/pulp-platform/{{ repo }}/blob/{{ branch }}/util/container/README.md). For additional information on the Docker container refer to that document.

### Installation

{%
   include-markdown '../../util/container/README.md'
   start="## Installation"
   end="## Usage"
   comments=false
   heading-offset=1
%}

<!--start-section-2-->

## IIS environment setup

To make sure the right versions of each tool are picked up on your IIS machine and install additional tools, run:

```bash
source iis-setup.sh
```

Have a look inside the script. You will want to add some of the steps contained therein to your shell startup file, e.g. exporting environment variables and activating the Python virtual environment. This way, every time you open a new shell, your environment will be ready for developing on Snitch, and you won't have to repeat the installation steps.

<!--end-section-2-->
