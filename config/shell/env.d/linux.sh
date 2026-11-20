# shellcheck shell=sh

export PNPM_HOME="${PNPM_HOME:-$XDG_DATA_HOME/pnpm}"

# Do NOT export QT_QPA_PLATFORMTHEME here. This file is sourced by the
# display manager's login shell, so the value leaks into the whole graphical
# session. Under KDE Plasma, "gtk3" makes kwin_wayland call gtk_init() before
# any display exists; GTK prints "cannot open display:" and exits, so the
# compositor never starts and you get a black screen after login.
# Plasma sets its own platform theme; on other desktops set it per-session
# (e.g. in that desktop's environment.d) rather than in the login profile.
