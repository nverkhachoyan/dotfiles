# Dotfiles

Personal user-space configuration lives in `config/`, with a few home-level
files in `home/`. GNU Stow links them into `~/.config` and `$HOME`:

```sh
./scripts/link-configs.sh
```

GNU Stow is required. The bootstrap installs it on macOS and on Linux distros
with a package list.

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
`scripts/bootstrap-linux.sh` on Linux. Both install packages, link configs and
then run `scripts/install-toolchains.sh`, which installs everything in
`config/mise/config.toml` and the stable Rust toolchain.

macOS packages come from `profiles/darwin/Brewfile`. On Linux they come from
`profiles/linux/<distro>/packages.txt`, after running that profile's `setup.sh`
if it has one. Distros without a profile only get configs linked.
The Nerd Fonts the terminal configs use come from
`scripts/install-fonts-linux.sh`, since distros don't package them.

Files that would block a link are renamed to `<name>.bak`.

Shell startup files (`~/.profile`, `~/.bashrc`, `~/.zprofile`, `~/.zshrc`) are
not links. They are small local files that load the shared versions in
`config/shell/`, so installers that append to them don't change the repo.
Move anything worth keeping from them into the repo.

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

Tool versions are pinned in `config/mise/config.toml`; run `mise outdated` to
see updates. Set `RUST_TOOLCHAIN` to install a Rust version other than stable.
