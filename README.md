Styles
======

This repository contains style/linting configuration files for reuse in other projects.

How to Use
----------

First, add this library as a submodule to a project:

```
git submodule add ../../edahlseng/styles modules/styles

# Note 1: Using a relative path above allows us to avoid hardcoding the protocol
# that Git uses when checking out the submodule (it will use the same protocol as
# whatever a user uses to checkout the project's root repository). This relative
# path only works, however, if the target project is hosted on GitHub.
```

Next, run the setup script:

```
./modules/styles/scripts/setup.sh
```
