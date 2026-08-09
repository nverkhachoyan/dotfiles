# shellcheck shell=sh

if [ -n "${BASH_VERSION:-}" ]; then
  case "$-" in
    *i*)
      # shellcheck source=/dev/null
      [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
      ;;
    *)
      # shellcheck source=/dev/null
      [ -f "$HOME/.config/shell/env.sh" ] && . "$HOME/.config/shell/env.sh"
      ;;
  esac
else
  # shellcheck source=/dev/null
  [ -f "$HOME/.config/shell/env.sh" ] && . "$HOME/.config/shell/env.sh"
fi

export PATH="$HOME/.local/bin:$PATH"
