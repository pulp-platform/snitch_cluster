# Contribution guidelines

Thank you for your interest in contributing to this project!  
We welcome external contributions and aim to make the process as smooth as possible.

## Workflow

1. **Fork the repository**  
   Please begin by creating a public fork of the repository on your own GitHub account.
   We disabled the creation of branches on the upstream repository for all users to prevent that stale branches are left hanging around.

2. **Enable the CI on your fork**  
   Enable Github Actions on your fork to run the CI.
   This will run a broader set of jobs than the PR-triggered CI, which require permissions on the repo's cache and container registry.
   The maintainers will check your fork's CI to validate your PR.

3. **Open a PR to `develop`**  
   Once your changes are ready, open a PR targeting the `develop` branch (**not** `main`).
   If your contributions are still a work-in-progress, e.g. some of the CI checks on your fork are still failing, please open the PR as a draft.
   Once your PR is merged into `develop`, additional CI jobs will run on our internal servers, with access to commercial licenses and proprietary tools.
   The maintainers will take care of any issues, and push the contributions to `main` once all issues are fixed.  


## Coding guidelines

The Github CI includes several linting checks. You may refer to the CI scripts for more details.

You can fix the formatting issues reported on C/C++ sources in an automated way, using the following command:
```shell
clang-format-10.0.1 -style=file -i <paths_to_the_sources>
```

## Communication

If you're planning a larger contribution or need clarification, feel free to open an issue. We're happy to help guide you.
