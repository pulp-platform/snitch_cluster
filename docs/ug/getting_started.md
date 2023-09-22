<!--start-section-1-->

# Getting Started

## Installation

Clone the repository:
```shell
git clone https://github.com/pulp-platform/{{ repo  }}.git --recurse-submodules
```

If you had already cloned the repository without the `--recurse-submodules` flag, clone its submodules:
```shell
git submodule init --recursive
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

To make sure the right versions of each tool are picked up, set the following environment variables, e.g. in a bash shell:

```bash
export PYTHON="/usr/local/anaconda3-2022.05/bin/python3"
export BENDER="bender-0.27.1"
export CC="gcc-9.2.0"
export CXX="g++-9.2.0"
export LLVM_BINROOT="/usr/pack/riscv-1.0-kgf/pulp-llvm-0.12.0/bin"
# As a temporary workaround (until correct tool versions are installed system-wide):
export PATH=/home/colluca/snitch/bin:$PATH
export PATH=/usr/scratch/dachstein/colluca/opt/verible/bin:$PATH
```

Add these commands to your shell startup file (e.g. `~/.bashrc` if you use bash as the default shell) to ensure that the environment is set up correctly every time you open a new shell.

Create a Python virtual environment:

```shell
$PYTHON -m venv ~/.venvs/snitch_cluster
```

Activate your environment, e.g. in a bash shell:

```bash
source ~/.venvs/snitch_cluster/bin/activate
```

You may want to add the last command to your shell startup file to ensure that the virtual environment is activated on every new shell you open.

Install the required packages in the currently active virtual environment:

```shell
pip install -r python-requirements.txt
```
<!--end-section-2-->
