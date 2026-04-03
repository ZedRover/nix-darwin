{ pkgs, ... }: {

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  nix.enable = false;

  launchd.daemons.nix-daemon.serviceConfig.EnvironmentVariables = {
    http_proxy  = "http://127.0.0.1:7890";
    https_proxy = "http://127.0.0.1:7890";
    all_proxy   = "socks5://127.0.0.1:7891";
  };
  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  programs.nix-index.enable = true;
  nixpkgs.config.allowUnfree = true;
  # nix.settings.trusted-substituters = [ "https://mirror.sjtu.edu.cn/nix-channels/store" ];
}
