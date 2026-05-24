{ ... }: {
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

  # 代理说明:
  # 原先写在这里的 launchd.daemons.nix-daemon 代理变量从来没生效过 —
  # nix-darwin 不管 Determinate 的 systems.determinate.nix-daemon。
  # 若需要让 nix-daemon 走代理,改 /Library/LaunchDaemons/systems.determinate.nix-daemon.plist
  # 或改用国内镜像 substituter(见上方 customSettings)。
  # 用户 shell 层的代理仍由 modules/apps.nix 的 environment.variables 提供(对 git/curl 等有效)。
}
