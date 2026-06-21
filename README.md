# Dotfiles

Personal user-space configuration lives in `config/` and can be linked into
`~/.config` with:

```sh
./scripts/link-configs.sh
```

On macOS, install apps and CLI tools with:

```sh
./scripts/bootstrap-macos.sh
```

Relocate supported home-root config dirs into `~/.config` with:

```sh
./scripts/relocate-home-configs.sh
```
