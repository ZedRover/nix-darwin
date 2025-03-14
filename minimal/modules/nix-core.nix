{ pkgs, ... }: {

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.enable = false;
  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  programs.nix-index.enable = true;
  nixpkgs.config.allowUnfree = true;
  # nix.settings.trusted-substituters = [ "https://mirror.sjtu.edu.cn/nix-channels/store" ];
}
