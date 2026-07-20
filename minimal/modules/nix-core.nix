{ lib, ... }:
let
  httpProxy = "http://127.0.0.1:6152";
  socksProxy = "socks5://127.0.0.1:6153";
  noProxy = "localhost,127.0.0.1,::1";

  proxyVariables = {
    http_proxy = httpProxy;
    https_proxy = httpProxy;
    all_proxy = socksProxy;
    no_proxy = noProxy;
    HTTP_PROXY = httpProxy;
    HTTPS_PROXY = httpProxy;
    ALL_PROXY = socksProxy;
    NO_PROXY = noProxy;
  };

  daemonProxyVariables = {
    http_proxy = httpProxy;
    https_proxy = httpProxy;
    all_proxy = socksProxy;
    no_proxy = noProxy;
  };

  updateDaemonVariable = name: value: ''
    current_value=$(/usr/libexec/PlistBuddy \
      -c "Print :EnvironmentVariables:${name}" \
      "$daemon_plist" 2>/dev/null || true)
    if [ "$current_value" != "${value}" ]; then
      /usr/libexec/PlistBuddy \
        -c "Delete :EnvironmentVariables:${name}" \
        "$daemon_plist" 2>/dev/null || true
      /usr/libexec/PlistBuddy \
        -c "Add :EnvironmentVariables:${name} string ${value}" \
        "$daemon_plist"
      daemon_proxy_changed=1
    fi
  '';
in
{
  # Determinate Nix 自管 /etc/nix/nix.conf。
  # 自定义守护进程级设置写到这里 → 会被合并进 /etc/nix/nix.custom.conf,升级不丢。
  # 启用此模块后 nix-darwin 自身的 nix 管理会被关闭(等价于 nix.enable = false)。
  determinateNix = {
    enable = true;
    customSettings = {
      # 保留 Determinate 安装器写入的默认值
      eval-cores = 0;

      # 示例:加镜像加速
      # extra-substituters = [ "https://mirror.sjtu.edu.cn/nix-channels/store" ];
      # extra-trusted-public-keys = [ "..." ];
      # max-jobs = "auto";
      # connect-timeout = 5;
    };
  };

  nixpkgs.config.allowUnfree = true;
  programs.nix-index.enable = true;
  # 把 comma 也指向 nix-index-database 的预构建数据库
  # (替代 environment.systemPackages 里的 comma)
  programs.nix-index-database.comma.enable = true;

  # Used by interactive shells and commands such as curl, git, and Homebrew.
  environment.variables = proxyVariables;

  # darwin-rebuild runs as root and the Homebrew activation runs through a
  # second sudo invocation as the primary user. Preserve proxies across both.
  security.sudo.extraConfig = ''
    Defaults env_keep += "http_proxy https_proxy all_proxy no_proxy HTTP_PROXY HTTPS_PROXY ALL_PROXY NO_PROXY"
  '';

  # Determinate Nix owns this LaunchDaemon, so nix-darwin's nix-daemon module
  # cannot set its environment. Re-apply the scoped proxy environment whenever
  # the installer or an upgrade rewrites the plist.
  system.activationScripts.postActivation.text = lib.mkAfter ''
    daemon_plist=/Library/LaunchDaemons/systems.determinate.nix-daemon.plist

    if [ ! -f "$daemon_plist" ]; then
      echo >&2 "warning: Determinate Nix daemon plist not found; daemon proxy was not configured"
    else
      daemon_proxy_backup=$(mktemp -t determinate-nix-daemon.plist.XXXXXX)
      cp "$daemon_plist" "$daemon_proxy_backup"
      daemon_proxy_changed=0

      if ! /usr/libexec/PlistBuddy -c "Print :EnvironmentVariables" "$daemon_plist" >/dev/null 2>&1; then
        /usr/libexec/PlistBuddy -c "Add :EnvironmentVariables dict" "$daemon_plist"
        daemon_proxy_changed=1
      fi

      ${lib.concatStringsSep "\n" (lib.mapAttrsToList updateDaemonVariable daemonProxyVariables)}

      if [ "$daemon_proxy_changed" -eq 1 ]; then
        if ! /usr/bin/plutil -lint "$daemon_plist" >/dev/null; then
          cp "$daemon_proxy_backup" "$daemon_plist"
          rm -f "$daemon_proxy_backup"
          echo >&2 "error: failed to write a valid Determinate Nix daemon plist"
          exit 1
        fi

        /bin/launchctl bootout system "$daemon_plist" 2>/dev/null || true
        if ! /bin/launchctl bootstrap system "$daemon_plist"; then
          cp "$daemon_proxy_backup" "$daemon_plist"
          /bin/launchctl bootstrap system "$daemon_plist" 2>/dev/null || true
          rm -f "$daemon_proxy_backup"
          echo >&2 "error: failed to reload the Determinate Nix daemon with proxy settings"
          exit 1
        fi
        /bin/launchctl kickstart -k system/systems.determinate.nix-daemon
        echo >&2 "Determinate Nix daemon proxy updated."
      fi

      rm -f "$daemon_proxy_backup"
    fi
  '';
}
