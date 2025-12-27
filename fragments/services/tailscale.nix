{ ... }:

{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    extraSetFlags = [ "--accept-dns=false" ];
  };
}
