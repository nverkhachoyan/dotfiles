export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-nvim}"
export HOMEBREW_NO_ENV_HINTS=1

export AWS_CONFIG_FILE="${AWS_CONFIG_FILE:-$XDG_CONFIG_HOME/aws/config}"
export AWS_SHARED_CREDENTIALS_FILE="${AWS_SHARED_CREDENTIALS_FILE:-$XDG_CONFIG_HOME/aws/credentials}"
export DOCKER_CONFIG="${DOCKER_CONFIG:-$XDG_CONFIG_HOME/docker}"
export KUBECONFIG="${KUBECONFIG:-$XDG_CONFIG_HOME/kube/config}"
export MODAL_CONFIG_PATH="${MODAL_CONFIG_PATH:-$XDG_CONFIG_HOME/modal/config.toml}"
export CODEX_HOME="${CODEX_HOME:-$XDG_CONFIG_HOME/codex}"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_history"
export DOTNET_CLI_HOME="$XDG_DATA_HOME/dotnet"
export GOPATH="$HOME/Dev/go"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export BUN_INSTALL="${BUN_INSTALL:-$HOME/.bun}"

case "$(uname -s 2>/dev/null || printf unknown)" in
  Darwin)
    export PNPM_HOME="$HOME/Library/pnpm"
    ;;
  Linux)
    export PNPM_HOME="$XDG_DATA_HOME/pnpm"
    export QT_QPA_PLATFORMTHEME="${QT_QPA_PLATFORMTHEME:-gtk3}"
    ;;
esac

path_prepend() {
  [ -n "$1" ] || return

  case ":$PATH:" in
    *":$1:"*)
      ;;
    *)
      PATH="$1:$PATH"
      ;;
  esac
}

if [ -d "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin" ]; then
  path_prepend "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin"
fi

path_prepend "$GOPATH/bin"
path_prepend "$PNPM_HOME"
path_prepend "$CARGO_HOME/bin"
path_prepend "$BUN_INSTALL/bin"
path_prepend "$HOME/.lmstudio/bin"
path_prepend "$HOME/.local/share/mise/shims"
path_prepend "/usr/local/sbin"
path_prepend "/usr/local/bin"
path_prepend "/opt/homebrew/sbin"
path_prepend "/opt/homebrew/bin"
path_prepend "$HOME/bin"
path_prepend "$HOME/.local/bin"

export PATH

if [ -z "${SSH_AUTH_SOCK:-}" ]; then
  if [ -S "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" ]; then
    export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
  elif [ -S "$HOME/.1password/agent.sock" ]; then
    export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"
  fi
fi
