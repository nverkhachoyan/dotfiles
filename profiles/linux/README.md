# Linux Profiles

Linux uses the shared configs under `config/`. Each distro folder here can add:

- `packages.txt`: packages to install, one per line (`#` comments allowed).
- `setup.sh`: optional, runs before the install (for example, enabling repos).

`scripts/install-packages-linux.sh` picks the folder from `/etc/os-release`.
Only `fedora/` exists today. Distros without a folder skip the package step
and only get configs linked.
