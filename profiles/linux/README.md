# Linux Profiles

Linux uses the shared configs under `config/`. Each distro folder here can add:

- `packages.txt`: packages to install, one per line (`#` comments allowed).
- `setup.sh`: optional, runs before the install (for example, enabling repos).

`scripts/install-packages-linux.sh` picks the folder from `/etc/os-release`.
Machines on the vm profile use `profiles/vm/<distro>/` instead (see
`profiles/vm/README.md`).
Only `fedora/` exists today. Distros without a folder skip the package step
and only get configs linked.

## keyd (Mac-style Cmd key)

`fedora/keyd/default.conf` makes Super behave like macOS Cmd: Super+C/V/T/W
and friends send Ctrl, Super+Space opens KRunner (Alt+Space), and Super+Tab
and Super+\` switch windows. It assumes KDE Plasma's default Alt+Tab and
Alt+Space shortcuts.

keyd isn't packaged for Fedora, so `scripts/install-keyd-linux.sh` builds the
pinned release, installs the config to `/etc/keyd/` and enables the service.
Bootstrap runs it on distros that have a `keyd/` folder, and only inside a KDE
Plasma session; otherwise it skips. Run it by hand with:

```sh
./scripts/install-keyd-linux.sh
```

Undo it with `sudo systemctl disable --now keyd`. Terminals still need
Ctrl+Shift+C/V; per-app overrides aren't set up yet.
