{ pkgs, ... }:

{
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "vfs objects" = [ "fruit" "streams_xattr" ];
        "fruit:metadata" = "stream";
        "fruit:veto_appledouble" = "no";
        "fruit:nfs_aces" = "no";
        "fruit:wipe_intentionally_left_blank_rfork" = "yes";
        "fruit:delete_empty_adfiles" = "yes";
        "fruit:posix_rename" = "yes";
        "fruit:copyfile" = "yes";
        "kernel oplocks" = "yes";
      };
      homes = {
        "valid users" = "%S, %D%w%S";
        "browseable" = "no";
        "writeable" = "yes";
      };
    };
  };
}
