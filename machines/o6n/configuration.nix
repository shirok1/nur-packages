# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../fragments/core.nix
    ../../fragments/networking.nix
    ../../fragments/users.nix
    ../../fragments/apps.nix
    ../../fragments/services/openssh.nix
    ../../fragments/services/tailscale.nix
    ../../fragments/services/daed.nix
    ../../fragments/services/nginx.nix
    ../../fragments/services/qbittorrent.nix
    ../../fragments/services/samba.nix
  ];

  networking.hostName = "nixo6n"; # Define your hostname.

  # Configure network proxy if necessary
  #networking.proxy.default = "http://192.168.88.190:6152/";
  #networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  zramSwap.enable = true;

  nix.settings = {
    substituters = [
      "https://cache.numtide.com"
    ];
    trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.shiroki = {
    packages = with pkgs; [
      nix-index
      ethtool
      gitui

      llm-agents.codex
    ];
  };

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    ghostty.terminfo
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # programs.nh = {
  #   clean.enable = true;
  #   clean.extraArgs = "--keep-since 4d --keep 3";
  #   flake = "/home/user/my-nixos-config"; # sets NH_OS_FLAKE variable for you
  # };

  # List services that you want to enable:

  services.avahi = {
    enable = true;
    publish.enable = true;
  };

  services.samba = {
    settings = {
      global = {
        "fruit:model" = "AirPort6";
      };
      EP990 = {
        "path" = "/drive/ep990";
        "browseable" = "yes";
        "writeable" = "yes";
      };
    };
  };

  services.nginx = {
    prependConfig = ''
      worker_processes auto;
    '';

    eventsConfig = ''
      use epoll;
    '';

    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedGzipSettings = true;
    experimentalZstdSettings = true;

    virtualHosts = {
      "ha.berry.shiroki.tech" = {
        # # Redirect HTTP -> HTTPS
        # forceSSL = true;
        # # Enable ACME (Let's Encrypt). Set to false if you manage certs yourself.
        # enableACME = true;
        # If you enable ACME, also set services.acme.email below (or set
        # services.nginx.extraConfig as needed).
        locations = {
          "/" = {
            proxyPass = "http://[::1]:8123";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_buffering off;
            '';
          };
        };
      };
      "qbt.berry.shiroki.tech" = {
        # # Redirect HTTP -> HTTPS
        # forceSSL = true;
        # # Enable ACME (Let's Encrypt). Set to false if you manage certs yourself.
        # enableACME = true;
        # If you enable ACME, also set services.acme.email below (or set
        # services.nginx.extraConfig as needed).
        locations = {
          "/" = {
            proxyPass = "http://[::1]:8080";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_buffering off;
            '';
          };
        };
      };
      "jellyfin.berry.shiroki.tech" = {
        # # Redirect HTTP -> HTTPS
        # forceSSL = true;
        # # Enable ACME (Let's Encrypt). Set to false if you manage certs yourself.
        # enableACME = true;
        # If you enable ACME, also set services.acme.email below (or set
        # services.nginx.extraConfig as needed).
        locations = {
          "/" = {
            proxyPass = "http://[::1]:8096";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_buffering off;
            '';
          };
        };
      };
    };
  };

  # If you enabled ACME above, configure the email address for registration.
  # Uncomment and set your email if you want automatic Let's Encrypt certs.
  # services.acme = {
  #   acceptTerms = true;
  #   email = "you@example.com";
  #   certs = {
  #     "your.hass.domain" = {
  #       webroot = "/var/www/letsencrypt";
  #     };
  #   };
  # };

  # systemd = {
    #settings = {
    #  Manager = { RuntimeWatchdogSec = "30s"; WatchdogDevice = "/dev/watchdog0"; };
    #};
  # };

  services.home-assistant = {
    enable = true;
    openFirewall = true;
    extraComponents = [
      # Components required to complete the onboarding
      "analytics"
      "google_translate"
      "met"
      "radio_browser"
      "shopping_list"
      # Recommended for fast zlib compression
      # https://www.home-assistant.io/integrations/isal
      "isal"

      "apple_tv"
      "esphome"
      "homekit"
      "homekit_controller"
      "mqtt"
      "mqtt_eventstream"
      "mqtt_json"
      "mqtt_room"
      "mqtt_statestream"
      "ping"
      "qbittorrent"
      "sonos"
      "switchbot"
      "tasmota"
      "thread"
      "upnp"
      "waqi"
      "xiaomi_ble"

      "ffmpeg"
      "zeroconf"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = { };
      "automation ui" = "!include automations.yaml";
      "scene ui" = "!include scenes.yaml";
      "script ui" = "!include scripts.yaml";

      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [
          "127.0.0.1"
          "::1"
        ];
      };
    };
    customComponents = with pkgs.home-assistant-custom-components; [
      xiaomi_home
    ];
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "shiroki";
  };

  services.clickhouse = {
    enable = true;
    serverConfig = {
      listen_host = "::";
      http_port = 8234;
      tcp_port = 9000;
    };
  };

  services.snell-server = {
    package = pkgs.shirok1.snell-server;
    settings = {
      snell-server = {
        listen = "0.0.0.0:13831";
        psk = "this_is_fake";
        ipv6 = "true";
      };
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    80
    443
    8080
    8234
    9000
    13831
    21064 # Home Assistant HomeKit Bridge
    1400 # Home Assistant Sonos
    1443 # Home Assistant Sonos
  ];
  networking.firewall.allowedUDPPorts = [ 13831 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}
