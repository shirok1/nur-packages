{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    helix
    xh
    nixd
    nil
    htop
    jq
    nvme-cli
    usbutils
    tmux
    zellij
    compose2nix
    nixfmt-rfc-style
    nixfmt-tree
    binutils
    patchelf
    libtree
  ];

  environment.etc."vuetorrent".source = "${pkgs.vuetorrent}/share/vuetorrent";

  programs.mtr.enable = true;
  programs.nexttrace.enable = true;
  programs.zsh.enable = true;
  programs.fish.enable = true;
  programs.nh.enable = true;

  virtualisation.docker = {
    enable = true;
    daemon.settings.experimental = true;
  };
}
