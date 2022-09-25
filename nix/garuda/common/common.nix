{ pkgs, lib, garuda-lib, config, meshagent, ... }: {
  imports = [
    ./users.nix
    ./acme.nix
    ./nginx.nix
    ./hardening.nix
  ];

  # Network stuff
  networking = {
    nameservers = [ "1.1.1.1" ];
    useDHCP = false;
    usePredictableInterfaceNames = true;
  }; 

  # Locales & timezone
  time.timeZone = "Europe/Berlin";
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    supportedLocales = [ "en_GB.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
  };
  console = {
    keyMap = "de";
    font = "Lat2-Terminus18";
  };

  # Home-manager configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.nico = import ../home/nico.nix;
  };

  # Programs & global config
  programs.mosh.enable = true;
  programs.fish = {
    enable = true;
    shellAbbrs = 
      {
        "reb" = "sudo nixos-rebuild switch -L";
        "roll" = "sudo nixos-rebuild switch --rollback";
        "su" = "sudo su -";
      };
    shellAliases =
      {
        "su" = "sudo su -";
        "egrep" = "egrep --color=auto";
        "fgrep" = "fgrep --color=auto";
        "dir" = "dir --color=auto";
        "ip" = "ip --color=auto";
        "vdir" = "vdir --color=auto";
        "bat" = "bat --style header --style snip --style changes";
        "ls" = "exa -al --color=always --group-directories-first --icons";
        "psmem" = "ps auxf | sort -nr -k 4";
        "psmem10" = "ps auxf | sort -nr -k 4 | head -1";
        "tarnow" = "tar acf ";
        "untar" = "tar zxvf ";
        "wget" = "wget -c";
      };
    shellInit = ''
      set fish_greeting
    '';
  };

  # Services 
  services = {
    vnstat.enable = true;
    openssh.enable = true;
    garuda-meshagent = {
      agentBinary = if pkgs.hostPlatform.system == "aarch64-linux" then meshagent.aarch64 else meshagent.x86_64;
      enable = lib.mkDefault true;
      mshFile = garuda-lib.secrets.meshagent_msh;
    };
    zerotierone = {
      enable = true;
      joinNetworks = [ garuda-lib.secrets.zerotier_network ];
    };
    garuda-monitoring = {
      enable = true;
      parent = "10.241.0.10";
    };
    earlyoom = {
      enable = true;
      freeMemThreshold = 5;
      freeSwapThreshold = 5;
    };
    locate = {
      enable = true;
      localuser = null;
      locate = pkgs.plocate;
    };
  };

  # Docker
  virtualisation.docker = {
    autoPrune.enable = true;
    autoPrune.flags = [ "-a" ];
  };

  # Environment
  environment = {
    systemPackages = with pkgs; [ python3 micro htop git screen ];
    variables = { MOSH_SERVER_NETWORK_TMOUT="604800"; };
  };

  # General nix settings
  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 2d";
    };
    package = pkgs.unstable.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Disable generation of manpages
  documentation.man.enable = false;
}
