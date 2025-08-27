{ pkgs, ... }:
{
  ##########################################################################
  #
  #  Install all apps and packages here.
  #
  #  NOTE: Your can find all available options in:
  #    https://daiderd.com/nix-darwin/manual/index.html
  #
  #
  ##########################################################################

  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331
  environment.systemPackages = with pkgs; [
    axel
    bat
    bazel
    cmake
    comma
    eza
    fswatch
    fzf
    git
    git-lfs
    htop-vim
    inetutils
    mold
    ninja
    nix-du
    nixpkgs-fmt
    nixfmt-rfc-style
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
  environment.variables = {
    # HOMEBREW_API_DOMAIN = "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api";
    # HOMEBREW_BOTTLE_DOMAIN = "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles";
    # HOMEBREW_BREW_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git";
    # HOMEBREW_CORE_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git";
    # HOMEBREW_PIP_INDEX_URL = "https://pypi.tuna.tsinghua.edu.cn/simple";
  };
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };

    taps = [
      "beeftornado/rmtree"
      "buo/cask-upgrade"
      "homebrew/bundle"
      "homebrew/command-not-found"
      "homebrew/services"
      "sunnyyoung/repo"
    ];

    # `brew install`
    brews = [
      ### START BREWS ###
      "aria2"
      "asitop"
      "brew-cask-completion"
      "clang-format"
      "coreutils"
      "duf"
      "enca"
      "ffmpeg"
      "fnm"
      "fontconfig"
      "fzf"
      "gh"
      "gitwatch"
      "iperf3"
      "iproute2mac"
      "juliaup"
      "just"
      "latexindent"
      "libomp"
      "maclaunch"
      "macos-trash"
      "macvim"
      "mosh"
      "ncdu"
      "neofetch"
      "netcat"
      "open-mpi"
      "rust"
      "ta-lib"
      "tailscale"
      "telnet"
      "trzsz-ssh"
      ### END BREWS ###
    ];

    casks = [
      ### START CASKS ###
      "1password"
      "1password-cli"
      "adrive"
      "aldente"
      "baidunetdisk"
      "balenaetcher"
      "bartender"
      "betterdisplay"
      "bettertouchtool"
      "chatgpt"
      "claude"
      "cursor"
      "easydict"
      "emclient"
      "fliqlo"
      "free-download-manager"
      "hyper"
      "iina"
      "input-source-pro"
      "ipynb-quicklook"
      "itsycal"
      "latest"
      "linearmouse"
      "mactex-no-gui"
      "maczip"
      "microsoft-excel"
      "microsoft-powerpoint"
      "microsoft-teams"
      "microsoft-word"
      "marginnote"
      "miniforge"
      "mos"
      "neteasemusic"
      "notchnook"
      "obsidian"
      "omnidisksweeper"
      "onedrive"
      "orbstack"
      "parallels-client"
      "pictureview"
      "prettyclean"
      "qlcolorcode"
      "qlmarkdown"
      "qlstephen"
      "qlvideo"
      "qq"
      "qqmusic"
      "quicklook-json"
      "quicklookase"
      "rustdesk"
      "skim"
      "snipaste"
      "telegram"
      "temurin@21"
      "tencent-lemon"
      "tencent-meeting"
      "termius"
      "trunk-io"
      "visual-studio-code"
      "vnc-viewer"
      "wechat"
      "wechattweak-cli"
      "wechatwork"
      "wetype"
      "youku"
      "zoom"
      "zotero@beta"
      ### END CASKS ###

      ### START FONTS ###
      "font-azeret-mono"
      "font-cascadia-code"
      "font-cascadia-code-pl"
      "font-cascadia-mono"
      "font-cascadia-mono-pl"
      "font-code-new-roman-nerd-font"
      "font-fira-code"
      "font-hack"
      "font-hack-nerd-font"
      "font-hubot-sans"
      "font-intel-one-mono"
      "font-juliamono"
      "font-mona-sans"
      "font-roboto"
      "font-roboto-flex"
      "font-roboto-mono"
      "font-roboto-mono-for-powerline"
      "font-roboto-mono-nerd-font"
      "font-roboto-serif"
      "font-roboto-slab"
      "font-sf-mono"
      "font-sf-mono-for-powerline"
      "font-intone-mono-nerd-font"
      "font-lxgw-wenkai"
      "font-0xproto"
      "font-cascadia-code-nf"
      "font-cascadia-mono-nf"
      "font-maple-mono"
      "font-maple-mono-nf"
      "font-maple-mono-cn"
      "font-maple-mono-nf-cn"
      ### END FONTS ###
    ];
  };
}
