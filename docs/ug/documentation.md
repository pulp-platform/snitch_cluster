# Documentation

Documentation pages for the Snitch cluster are hosted under `docs`. Static
`html` documentation is built and deployed from the latest `main` branch by the
CI. We use [mkdocs](https://www.mkdocs.org/) together with the [material
theme](https://squidfunk.github.io/mkdocs-material/).

You can build a static copy of the `html` documentation by
executing (in the root of this repository):

```shell
make docs
```

Documentation for the Python sources in this repository is generated from the
docstrings contained within the sources themselves, using
[mkdocstrings](https://mkdocstrings.github.io/).
Documentation for the C sources in this repository is generated from the
Doxygen-style comments within the sources themselves, using Doxygen.

## Organization

The `docs` folder is organized as follows:

* `rm`: Reference manuals, listings and detailed design decisions.
* `ug`: User guides, more tutorial style texts to get contributors and user
  up-to-speed.
