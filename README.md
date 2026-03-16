# My nix config for macOS + Linux

This config uses a host matrix:
- macOS hosts use `nix-darwin` for system settings only
- Linux hosts use standalone Home Manager (non-NixOS)

Manual user configs live in `config/` and can be linked into `~/.config` with:

```sh
./scripts/link-configs.sh
```

On macOS, install apps and CLI tools outside Nix with:

```sh
./scripts/bootstrap-macos.sh
```

Relocate supported home-root config dirs into `~/.config` with:

```sh
./scripts/relocate-home-configs.sh
```

Apply macOS host config:

```sh
sudo darwin-rebuild switch --flake .#iloveyou
```

Apply Linux host config:

```sh
home-manager switch --flake .#nverk@workhorse
```
