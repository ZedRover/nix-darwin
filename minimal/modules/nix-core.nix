{ lib, ... }:
let
  httpProxy = "http://127.0.0.1:6152";
  socksProxy = "socks5://127.0.0.1:6153";
  noProxy = "localhost,127.0.0.1,::1";

  # Scoped to brew bundle only. Do not put these in environment.variables:
  # set-environment would export them to every interactive shell, and
  # curl/git/nix fail when the local proxy is down.
  # Keep the URLs in sync with modules/nix-daemon.sh (Determinate daemon).
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

  # activate uses `env -i`; inject proxy into the brew invocation directly.
  homebrew.onActivation.extraEnv = proxyVariables;

  # nix.enable = false makes nix-darwin restore org.nixos.nix-daemon from the
  # unmanaged profile. Run immediately after that fragment: drop the official
  # daemon and re-apply proxy env on Determinate's plist (it owns the daemon,
  # so nix-darwin cannot set launchd.daemons.*.environment).
  system.activationScripts.nix-daemon.text = lib.mkAfter (builtins.readFile ./nix-daemon.sh);
}
