# Copyright 2025 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0


"""
This script emits a recipe.yaml for rattler-build.
Such a script can hardly be called idiomatic,
but otherwise we have to define dependencies in at least 3 different places.
This script mainly serves to prevent code duplication.
"""

import tomllib


def add_dependency(dependency: str, version: str):
    print(f"        - {dependency} {version}")


def print_conda_deps_as_yaml(pixiconfig: dict):
    for dependency, version in pixiconfig.items():
        add_dependency(dependency, version)


PREAMBLE = r"""
# Copyright 2025 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

context:
  git_repo_url: "https://github.com/kuleuven-micas/snax_cluster"
  latest_tag: ${{ git.latest_tag( git_repo_url ) }}
  version: ${{ latest_tag[1:] }}

source:
  git: https://github.com/KULeuven-MICAS/snax_cluster
  tag: v${{ version }}

about:
  homepage: https://github.com/KULeuven-MICAS/snax_cluster
  summary: "A heterogeneous accelerator-centric compute cluster"

outputs:"""
PACKAGE_DEF = """  - package:
      name: {}
      version: ${{{{ version }}}}
    requirements:
      {}:"""
PACKAGE_BUILD = """    build:
      script:
        - {}"""

if __name__ == "__main__":
    # Get conda dependencies from pixi.toml
    with open("../../pixi.toml", "rb") as pixitoml:
        pixiconfig = tomllib.load(pixitoml)["dependencies"]
        print(PREAMBLE)
        # Prebuilt package -> all deps are build deps, build.sh prebuilds
        print(PACKAGE_DEF.format("snax-cluster-prebuilt", "build"))
        add_dependency("git", "")
        add_dependency("wget", "")
        print_conda_deps_as_yaml(pixiconfig)
        print(PACKAGE_BUILD.format("build.sh"))
        # Dev package -> all deps are run deps, build-dev.sh does nothing
        print(PACKAGE_DEF.format("snax-cluster-dev", "run"))
        # Add prebuilt package to dev package
        pin = '${{ pin_subpackage("snax-cluster-prebuilt", exact=True) }}'
        add_dependency(pin, "")
        print_conda_deps_as_yaml(pixiconfig)
        print(PACKAGE_BUILD.format("build-dev.sh"))
