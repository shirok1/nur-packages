{ pkgs, ... }:

{
  systemd = {
    packages = [ pkgs.qbittorrent-nox ];
    services."qbittorrent-nox@shiroki" = {
      overrideStrategy = "asDropin";
      wantedBy = [ "multi-user.target" ];
    };
  };

  services.qbittorrent-clientblocker = {
    enable = true;
    package = pkgs.shirok1.qbittorrent-clientblocker;
    settings = {
      checkUpdate = false;
      clientType = "qBittorrent";
      clientURL = "http://127.0.0.1:8080/api";
      clientUsername = "shiroki";
    };
  };
}
