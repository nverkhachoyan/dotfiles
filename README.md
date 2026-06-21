# Dotfiles

Personal user-space configuration lives in `config/` and can be linked into
`~/.config` with:

```sh
./scripts/link-configs.sh
```

Shared config is the default. OS-specific setup lives in:

- `config/shell/env.d/darwin.sh`
- `config/shell/env.d/linux.sh`
- `profiles/darwin/`
- `profiles/linux/`

Bootstrap the current OS with:

```sh
./scripts/bootstrap
```

The dispatcher runs `scripts/bootstrap-darwin.sh` on macOS and
`scripts/bootstrap-linux.sh` on Linux. The Darwin bootstrap links configs,
relocates supported home-root configs, and installs packages from
`profiles/darwin/Brewfile`. The Linux bootstrap links shared configs only;
package installation is left to the distro or Omarchy for now.

Relocate supported home-root config dirs into `~/.config` with:

```sh
./scripts/relocate-home-configs.sh
```
