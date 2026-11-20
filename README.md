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
`config/mise/config.toml`, including the stable Rust toolchain (mise drives
rustup for it).

Cross-platform CLI tools (ripgrep, fd, bat, fzf, delta, gh, neovim, uv and
so on) come from mise, so both OSes get the same versions. The OS package
lists only hold system pieces: compilers and debuggers, zsh plugins, GUI apps,
and the few tools the shell needs before mise is set up (starship, direnv,
zoxide). eza and btop stay there too because they don't ship macOS binaries.

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

Bash and zsh are both configured. Bootstrap doesn't change the login shell;
run `chsh -s "$(command -v zsh)"` to switch to zsh.

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

Tools are listed in `config/mise/config.toml`, mostly as `latest`, and
`config/mise/mise.lock` pins the exact version and checksum of each one for
Linux x64 and macOS arm64. Bootstrap installs what the lockfile says, so
nothing moves until you update it. Run `mise outdated` to see updates; after
editing `config.toml`, run `mise lock --global` to refresh the lockfile
(`scripts/check` fails if it's out of date). The `locks/` folder next to it
holds the dependency locks for npm and pipx tools. Change the `rust` entry in
`config.toml` to use a Rust version other than stable.

Update everything with:

```sh
./scripts/update            # or pick sections: system, tools, nvim
```

`system` upgrades the OS packages (and Flatpaks on Linux) and installs any
new entries in the package lists. `tools` moves each mise tool to its newest
allowed version, Rust stable included, and rewrites `mise.lock`. `nvim` syncs
the Neovim plugins and updates `lazy-lock.json`. Review and commit the
lockfile diffs it lists at the end.

See where the machine and the package lists disagree with:

```sh
./scripts/drift
```

It lists packages from the lists that aren't installed, packages you
installed by hand that aren't in the lists, and OS packages that duplicate a
tool mise now provides. It never installs or removes anything. On Fedora it
reads `dnf history`, ignoring what the OS image came with.
