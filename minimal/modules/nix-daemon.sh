#!/bin/bash
# Shared by nix-darwin activation and `just configure-daemon`.
# Runs as root. Safe to re-run: no-ops when state already matches.
(
  set -euo pipefail

  leftover_nix_daemon_plist=/Library/LaunchDaemons/org.nixos.nix-daemon.plist
  if /bin/launchctl print system/org.nixos.nix-daemon >/dev/null 2>&1 \
     || [ -f "$leftover_nix_daemon_plist" ]; then
    /bin/launchctl bootout system "$leftover_nix_daemon_plist" 2>/dev/null || true
    /bin/launchctl bootout system/org.nixos.nix-daemon 2>/dev/null || true
    /bin/launchctl disable system/org.nixos.nix-daemon 2>/dev/null || true
    rm -f "$leftover_nix_daemon_plist"
    echo >&2 "Removed leftover official Nix daemon; Determinate Nix owns nix-daemon."
  fi

  # Keep in sync with proxyVariables in nix-core.nix (Homebrew extraEnv).
  daemon_plist=/Library/LaunchDaemons/systems.determinate.nix-daemon.plist
  if [ ! -f "$daemon_plist" ]; then
    echo >&2 "warning: Determinate Nix daemon plist not found; daemon proxy was not configured"
    exit 0
  fi

  daemon_proxy_backup=$(mktemp -t determinate-nix-daemon.plist.XXXXXX)
  trap 'rm -f "$daemon_proxy_backup"' EXIT
  cp "$daemon_plist" "$daemon_proxy_backup"
  daemon_proxy_changed=0

  if ! /usr/libexec/PlistBuddy -c "Print :EnvironmentVariables" "$daemon_plist" >/dev/null 2>&1; then
    /usr/libexec/PlistBuddy -c "Add :EnvironmentVariables dict" "$daemon_plist"
    daemon_proxy_changed=1
  fi

  proxy_entries=(
    "http_proxy=http://127.0.0.1:6152"
    "https_proxy=http://127.0.0.1:6152"
    "all_proxy=socks5://127.0.0.1:6153"
    "no_proxy=localhost,127.0.0.1,::1"
  )

  for entry in "${proxy_entries[@]}"; do
    name=${entry%%=*}
    value=${entry#*=}
    current_value=$(/usr/libexec/PlistBuddy \
      -c "Print :EnvironmentVariables:${name}" \
      "$daemon_plist" 2>/dev/null || true)
    if [ "$current_value" != "$value" ]; then
      /usr/libexec/PlistBuddy \
        -c "Delete :EnvironmentVariables:${name}" \
        "$daemon_plist" 2>/dev/null || true
      /usr/libexec/PlistBuddy \
        -c "Add :EnvironmentVariables:${name} string ${value}" \
        "$daemon_plist"
      daemon_proxy_changed=1
    fi
  done

  if [ "$daemon_proxy_changed" -eq 1 ]; then
    if ! /usr/bin/plutil -lint "$daemon_plist" >/dev/null; then
      cp "$daemon_proxy_backup" "$daemon_plist"
      echo >&2 "error: failed to write a valid Determinate Nix daemon plist"
      exit 1
    fi

    /bin/launchctl bootout system "$daemon_plist" 2>/dev/null || true
    if ! /bin/launchctl bootstrap system "$daemon_plist"; then
      cp "$daemon_proxy_backup" "$daemon_plist"
      /bin/launchctl bootstrap system "$daemon_plist" 2>/dev/null || true
      echo >&2 "error: failed to reload the Determinate Nix daemon with proxy settings"
      exit 1
    fi
    /bin/launchctl kickstart -k system/systems.determinate.nix-daemon
    echo >&2 "Determinate Nix daemon proxy updated."
  fi
) || exit 1
