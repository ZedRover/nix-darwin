{ pkgs, ... }: {
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
  #
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331
  environment.systemPackages = with pkgs; [
    axel
    bat
    bazel

    gh
    git
    git-lfs

    htop-vim
    inetutils

    mold
    mosh

    nixpkgs-fmt
    ninja

    openssh
    pandoc
    parallel
    procs
    pstree
    smartmontools
    tldr
    tmux

    w3m
    wget

    yadm
    zellij

    exa
    fzf
    cmake
    helix
    comma
    comma
    nix-du
    fswatch
    postgresql
    pet
    ### END Nix ###
  ];
  environment.variables = {
    HOMEBREW_API_DOMAIN = "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api";
    HOMEBREW_BOTTLE_DOMAIN = "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles";
    HOMEBREW_BREW_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git";
    HOMEBREW_CORE_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git";
    HOMEBREW_PIP_INDEX_URL = "https://pypi.tuna.tsinghua.edu.cn/simple";
  };
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };

    taps = [
      "homebrew/cask-fonts"
      "homebrew/services"
      "homebrew/cask-versions"
      "beeftornado/rmtree"
      "homebrew/bundle"
      "homebrew/command-not-found"
      "sunnyyoung/repo"
      "buo/cask-upgrade"
    ];

    # `brew install`
    brews = [
      "bazel"
      "brew-cask-completion"
      "clang-format"
      "enca"
      "iperf3"
      "latexindent"
      "libomp"
      "maclaunch"
      "macvim"
      "ncdu"
      "neofetch"
      "rust"
      "ta-lib"
      "telnet"
      "aria2"
      "gitwatch"
      "coreutils"
      "wtfis"
      "macos-trash"
      "fnm"
      ### END BREWS ###
    ];

    casks = [
      "adrive"
      "aldente"
      "baidunetdisk"
      "balenaetcher"
      "bartender"
      "betterdummy"
      "bettertouchtool"
      "bose-updater"
      "cakebrew"
      "deepl"
      "fliqlo"
      "free-download-manager"
      "hyper"
      "ieasemusic"
      "iina"
      "imazing"
      "input-source-pro"
      "ipynb-quicklook"
      "julia"
      "linearmouse"
      "mactex-no-gui"
      "maczip"
      "miniforge"
      "monitorcontrol"
      "mos"
      "neteasemusic"
      "notion"
      "onedrive"
      "orbstack"
      "qlcolorcode"
      "qlimagesize"
      "qlmarkdown"
      "qlstephen"
      "qlvideo"
      "qq"
      "qqmusic"
      "quicklook-json"
      "quicklookase"
      "skim"
      "snipaste"
      "sourcetree"
      "tencent-lemon"
      "tencent-meeting"
      "termius"
      "uninstallpkg"
      "visual-studio-code"
      "vnc-viewer"
      "wechat"
      "wechattweak-cli"
      "wechatwork"
      "youku"
      "zoom"
      "zotero"
      "telegram"
      "shottr"
      "trunk-io"
      "rustdesk"
      ### Fonts ###
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


      "pictureview"
      "kuaitie"
      "spacedrive"
      "arc"
      "microsoft-word"
      "microsoft-excel"
      "omnidisksweeper"
      "microsoft-powerpoint"
      "microsoft-teams"
      "marginnote"
      "sfm"
      "prettyclean"
      "lulu"
      ### END CASKs ###
    ];
  };
}
