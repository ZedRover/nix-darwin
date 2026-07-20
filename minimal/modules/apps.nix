{ pkgs, ... }:
{
  ##########################################################################
  #
  #  Install all apps and packages here.
  #
  #  NOTE: All available options:
  #    https://daiderd.com/nix-darwin/manual/index.html
  #
  ##########################################################################

  environment.systemPackages = with pkgs; [
    ### START Nix ###
    axel
    bat
    bazel
    cmake
    eza
    fd
    fswatch
    fzf
    git
    git-lfs
    htop-vim
    inetutils
    ninja
    nix-du
    nixfmt
    openssh
    pandoc
    parallel
    pet
    postgresql
    procs
    pstree
    smartmontools
    tldr
    tmux
    w3m
    wget
    yadm
    zellij
    ### END Nix ###
  ];

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
      extraFlags = [ "--force-cleanup" ];
    };

    taps = [
      "beeftornado/rmtree"
      "buo/cask-upgrade"
      #"amir1376/tap"
    ];

    brews = [
      ### START BREWS ###
      "aria2"
      "asitop"
      "bitwarden-cli"
      "chsrc"
      "clang-format"
      "claude-squad"
      "cloudflared"
      "coreutils"
      "duf"
      "duti"
      "enca"
      "fastfetch"
      "ffmpeg"
      "fontconfig"
      "forgecode"
      "fzf"
      "gh"
      "gitwatch"
      "glow"
      "iperf3"
      "iproute2mac"
      "juliaup"
      "just"
      "latexindent"
      "libomp"
      "maclaunch"
      "macos-trash"
      "mise"
      "mosh"
      "ncdu"
      "neovim"
      "netcat"
      "nexttrace"
      "open-mpi"
      "pixi"
      "socat"
      "ta-lib"
      "tailscale"
      "telnet"
      "trzsz-ssh"
      "wakeonlan"
      ### END BREWS ###
    ];

    casks = [
      ### START CASKS ###
      #"ab-download-manager"
      "adrive"
      "aldente"
      "antigravity-cli"
      "baidunetdisk"
      "balenaetcher"
      "bartender"
      "betterdisplay"
      "bitwarden"
      "cc-switch"
      "chatgpt"
      "claude-code"
      "codex-app"
      "easydict"
      "fliqlo"
      "ghostty"
      "iina"
      "input-source-pro"
      "itsycal"
      "linearmouse"
      "logi-options+"
      "mactex-no-gui"
      "maczip"
      "marginnote"
      "microsoft-excel"
      "microsoft-powerpoint"
      "microsoft-teams"
      "microsoft-word"
      "mos@beta"
      "neteasemusic"
      "notchnook"
      "obsidian"
      "omnidisksweeper"
      "omnissa-horizon-client"
      "onedrive"
      "orbstack"
      "parallels-client"
      "pictureview"
      "prettyclean"
      "qq"
      "qqmusic"
      "rustdesk"
      "skim"
      "snipaste"
      "telegram"
      #"temurin@21"
      "tencent-lemon"
      "tencent-meeting"
      "termius"
      "trunk-io"
      "visual-studio-code"
      "vnc-viewer"
      "wechat"
      "wins"
      "youku"
      "zed"
      "zoom"
      "zotero@beta"
      ### END CASKS ###

      ### START FONTS ###
      "font-0xproto"
      "font-azeret-mono"
      "font-cascadia-code"
      "font-cascadia-code-nf"
      "font-cascadia-code-pl"
      "font-cascadia-mono"
      "font-cascadia-mono-nf"
      "font-cascadia-mono-pl"
      "font-caskaydia-mono-nerd-font"
      "font-code-new-roman-nerd-font"
      "font-fira-code"
      "font-fira-mono-nerd-font"
      "font-hack"
      "font-hack-nerd-font"
      "font-heavy-data-nerd-font"
      "font-hubot-sans"
      "font-intel-one-mono"
      "font-intone-mono-nerd-font"
      "font-juliamono"
      "font-lxgw-wenkai"
      "font-maple-mono"
      "font-maple-mono-cn"
      "font-maple-mono-nf"
      "font-maple-mono-nf-cn"
      "font-roboto"
      "font-roboto-flex"
      "font-roboto-mono"
      "font-roboto-mono-for-powerline"
      "font-roboto-mono-nerd-font"
      "font-roboto-serif"
      "font-roboto-slab"
      "font-sf-mono"
      "font-sf-mono-for-powerline"
      "font-share-tech-mono"
      ### END FONTS ###
    ];
  };
}
