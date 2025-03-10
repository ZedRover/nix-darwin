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
    helix
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
      "mrkai77/cask"
    ];

    # `brew install`
    brews = [
      ### START BREWS ###
      "aria2"
      "asitop"
      "brew-cask-completion"
      "clang-format"
      "coreutils"
      "enca"
      "fnm"
      "gh"
      "gitwatch"
      "iperf3"
      "latexindent"
      "libomp"
      "maclaunch"
      "macos-trash"
      "macvim"
      "mosh"
      "ncdu"
      "neofetch"
      "rust"
      "ta-lib"
      "telnet"
      "trzsz-ssh"
      "open-mpi"
      "netcat"
      "iproute2mac"
      "duf"
      ### END BREWS ###
    ];

    casks = [
      ### START CASKS ###
