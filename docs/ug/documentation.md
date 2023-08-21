# Documentation

Documentation of the generator and related infrastructure is hosted under
`docs`. Static `html` documentation is build from the latest `main` branch by
the CI. We use [mkdocs](https://www.mkdocs.org/) together with the [material
theme](https://squidfunk.github.io/mkdocs-material/). Before building the
documentation, make sure you have the required dependencies installed:

```shell
pip install -r docs/requirements.txt
```

After everything is installed, you can build a static copy of the `html` documentation by
executing (in the root directory):

```shell
make docs
```

## Organization

The `docs` folder is organized as follows:

* `rm`: Reference manuals, listings and detailed design decisions.
* `ug`: User guides, more tutorial style texts to get contributors and user
  up-to-speed.
* `schema`: Contains the JSON schema used for data validation and generation.
* `schema-doc`: Contains auto-generated documentation from the schema in the
  `schema` folder. The documentation is generated using
  [`adobe/jsonschema2md`](https://github.com/adobe/jsonschema2md).

<!-- ## IP Documentation -->

## Re-generate Documentation

Unfortunately, there isn't a good Python tool that generates schema to markdown
documents, hence, we rely on `adobe/jsonschema2md` which requires `node` and
`npm`. To re-generate the documentation execute (in the repository root):

```bash
jsonschema2md -d docs/schema/ -o docs/schema-doc -n
```
