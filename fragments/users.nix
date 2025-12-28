{ pkgs, ... }:

{
  users.users.shiroki = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" "input" "docker" ];
    shell = pkgs.fish;
    packages = with pkgs; [
      tree
      btop
      nurl
      nix-init
      gh
      (fastfetch.override {
        brightnessSupport = false;
        waylandSupport = false;
        x11Support = false;
        xfceSupport = false;
      })
      dua
      dust
      zoxide
      atuin
      eza
      just
    ];
  };
}
