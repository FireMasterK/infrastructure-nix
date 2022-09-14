{ config, garuda-lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./garuda/garuda.nix
  ];

  networking.interfaces.ens18.ipv4.addresses = [ {
    address = "78.129.140.86";
    prefixLength = 24;
  } ];
  networking.hostName = "garuda-test";
  networking.defaultGateway = "78.129.140.1";

  services.chaotic.enable = true;
  services.chaotic.cluster-name = "garuda-repo";
  services.chaotic.host = "repo2.garudalinux.org";
  services.chaotic.extraConfig = ''
export CAUR_DEPLOY_LABEL="Maximus 🐉"
export CAUR_TELEGRAM_TAG="@dr460nf1r3"
export CAUR_SIGN_KEY=0706B90D37D9B881
export CAUR_SIGN_USER=nico
export CAUR_PACKAGER="Garuda Builder <team@garudalinux.org>"
export CAUR_LOWER_PKGS+=(chaotic-mirrorlist chaotic-keyring)
  '';
  services.chaotic.db-name = "garuda";
  services.chaotic.routines = [ "hourly" ];
  services.chaotic.patches = [ ./garuda/services/chaotic/garuda.diff ];
  services.chaotic.useACMEHost = "garudalinux.org";

  services.syncthing = {
    enable = true;
    overrideDevices = true;
    overrideFolders = true;
    openDefaultPorts = true;
    configDir = config.services.syncthing.dataDir;
    cert = garuda-lib.secrets.syncthing.esxi.cert;
    key = garuda-lib.secrets.syncthing.esxi.key;
    devices = {
      "builds.garudalinux.org" = {
        id = garuda-lib.secrets.syncthing.garuda-build;
        addresses =  [ "dynamic, tcp://builds.garudalinux.org" ];
      };
    };
    folders = {
      "garuda" = {
        path = "/srv/http/repos/garuda";
        id = garuda-lib.secrets.syncthing.folders.garuda;
        devices = [ "builds.garudalinux.org" ];
        type = "sendonly";
      };
    };
    extraOptions = {
      gui = {
        apikey = "garudalinux";
      };
    };
  };

  systemd.services.syncthing-reset = {
    serviceConfig.Type = "oneshot";
    script = ''
      "${pkgs.curl}/bin/curl" -X POST -H "X-API-Key: garudalinux" http://localhost:8384/rest/db/override?folder=${garuda-lib.secrets.syncthing.folders.garuda}
    '';
  };
  systemd.timers.syncthing-reset = {
    wantedBy = [ "timers.target" ];
    timerConfig.OnCalendar = [ "hourly" ];
  };

  system.stateVersion = "22.05";
}
