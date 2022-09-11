{ pkgs, lib, garuda-lib, config, meshagent_x86_64, meshagent_aarch64, ... }: {
  imports = [
    ./users.nix
    ./acme.nix
    ./nginx.nix
  ];
  networking.nameservers = [ "1.1.1.1" ];

  zramSwap.enable = true;

  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;
  programs.mosh.enable = true;
  environment.variables = { MOSH_SERVER_NETWORK_TMOUT="604800"; };

  # TODO: Move this to a security.nix
  # Timeout TTY after 1 hour
  programs.bash.interactiveShellInit = ''if [[ $(tty) =~ /dev\/tty[1-6] ]]; then TMOUT=3600; fi'';
  console.keyMap = "de";

  services.garuda-meshagent.enable = lib.mkDefault true;
  services.garuda-meshagent.mshFile = garuda-lib.secrets.meshagent_msh;
  services.garuda-meshagent.agentBinary = if pkgs.hostPlatform.system == "aarch64-linux" then meshagent_aarch64 else meshagent_x86_64;

  virtualisation.docker.autoPrune.enable = true;
  virtualisation.docker.autoPrune.flags = [ "-a" ];

  environment.systemPackages = with pkgs; [ python3 micro htop git screen ];

  services.zerotierone.enable = true;
  services.zerotierone.joinNetworks = [ garuda-lib.secrets.zerotier_network ];

  services.garuda-monitoring.enable = true;
  services.garuda-monitoring.parent = "10.241.0.10";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.package = pkgs.unstable.nix;
}
