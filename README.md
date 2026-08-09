# Dotfiles

Personal user-space configuration lives in `config/`, with home-level shell
startup files in `home/`. GNU Stow links them into `~/.config` and `$HOME`:

```sh
./scripts/link-configs.sh
```

GNU Stow is required. On macOS it is installed by the Brewfile; on Linux,
install the `stow` package from your distribution.

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

Run the local validation suite with:

```sh
./scripts/check
```

Alacritty uses the committed Codex Noir theme by default. Select another
committed theme by changing the import in `config/alacritty/alacritty.toml`.

The macOS bootstrap pins language-tool versions by default. Override
`GOPLS_VERSION`, `PYLINT_VERSION`, `RUST_TOOLCHAIN`, or `STYLUA_VERSION` when
intentionally updating them.
