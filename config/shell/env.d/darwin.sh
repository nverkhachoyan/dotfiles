# shellcheck shell=sh

export PNPM_HOME="${PNPM_HOME:-$HOME/Library/pnpm}"

DOTFILES_PLATFORM_PATHS="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin"
for brew_prefix in /opt/homebrew /usr/local; do
  if [ -d "$brew_prefix/bin" ]; then
    DOTFILES_PLATFORM_PATHS="$brew_prefix/sbin:$brew_prefix/bin:$DOTFILES_PLATFORM_PATHS"
  fi
done
export DOTFILES_PLATFORM_PATHS
