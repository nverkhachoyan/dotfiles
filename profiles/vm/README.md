# VM Profile

For headless Linux servers and VMs you reach over SSH. Pick it once with:

```sh
./scripts/bootstrap --profile vm
```

The choice is saved in `~/.config/dotfiles/profile`, so later runs of
`scripts/bootstrap` and `scripts/update` reuse it. Delete that file (or run
with `--profile desktop`) to go back to the default.

Compared with the desktop profile, a VM:

- installs the packages in `<distro>/packages.txt` here instead of
  `profiles/linux/<distro>/`. Only `debian/` (Debian and Ubuntu) exists so far;
  its `setup.sh` adds mise's apt repository.
- installs only the mise tools in `tools.txt`. The rest of
  `config/mise/config.toml` stays uninstalled, and mise ignores it. Versions
  still come from `mise.lock`.
- skips the Nerd Fonts and keyd, and doesn't link the alacritty, ghostty and
  zed configs. A VM's own `~/.config/zed` (written by Zed's remote server) is
  left alone.
- follows the lockfiles in `scripts/update` instead of moving them: `tools`
  installs what `mise.lock` says and prunes the rest, and `nvim` restores the
  plugins in `lazy-lock.json`. Pull the repo first; update the lockfiles on a
  desktop and commit them there.

Shells, git, tmux, starship, ssh and Neovim use the same config as everywhere
else. Bootstrap doesn't change the login shell; run
`chsh -s "$(command -v zsh)"` to switch to zsh.
