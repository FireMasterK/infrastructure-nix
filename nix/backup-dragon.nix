{ garuda-lib
, pkgs
, ...
}: {
  imports = [ ./garuda/garuda.nix ./garuda/common/lxc.nix ];

  # Base configuration
  networking.hostName = "backup-dragon";
  networking.interfaces.eth0.ipv4.addresses = [
    {
      address = "192.168.1.70";
      prefixLength = 24;
    }
  ];
  networking.defaultGateway = "192.168.1.1";

  # Enable borg repositories, making them accessible by the borg user and people belonging to the backup group
  services.borgbackup.repos = {
    esxi-cloud = {
      authorizedKeys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1/X4im25wbEN1Y6f3Qh2KkzNn7jFlDCRYmWFNUsypM10WRQsa6sdCg7Yr/H0crl0wgp7W2Et2D8QZCobPaR0yy5cYmpi4bd2VSulRA07O9YZd6CjcapfTlCCETZdjf8gc3jcElYY9jHypY+vzK+UDI/bLRFxlVkJTkFBWeEC4PsS3YJvVmE62pl7QGsoHk8LoZe87b/0FxIvQ5NfgbcWMOWQCTahFKxZL+K/DCLcU0LYi1NocoCUANjlHHXpgd8NbH1bcMc0aCvl6s48ItwM2FnRnCmjCFCC0cjaDYaTs2h8En9dkl4dxNnowjoo0ohUKS9ffcLz6wxDnygqH8CXHsNTg/II2k1uLzhLKymiMjhhphqB1bj6eMBeQP59/b/9sv7XyPoSxN+/ITZRLNPWKQjHgFTpONOeOgmZpbIn0q+anp5dBCHodWK7ap5+C+g0Afbg6tRsAQuezj42jANwA8R9F8wwrAhjeWiQQWcuuuybjN1m2fU/OLpG/W8s+KQE= nico@esxi-cloud"
      ];
      group = "backup";
      path = "/backups/esxi-cloud";
      user = "borg";
    };
    esxi-forum = {
      authorizedKeys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCepbnSOD52/9m2vhS8gpK9bb6R0mHNs3HJ98dscC3GIr9t6NaMno9ZljQPJN+srKUX5GmLnLk7UQj3N1hn1ptP6xCbBpy7/3PTb1dnbHjHa3EcLU4NC3MuKKyN4JZDD9nSqC90J2mVGI0JtM7JN+KoJ0YiTV1aAaNnmzmXu0bpf2vdt/wjr2TevhpLx053LxE4JxLDVcTV59yF6KJW9/X5OaNE3JjSaHLbb8ZeJHDXHlwtd5D+5NDqYJzcHjBmlfO18JzJbQbyYIN/NNNSxIjaAgqxOIm/uGhgvAWT1RIqqqmiiBna82gwBdFQIbgOFW2bzQ7WE5TBlTa0ySCBCXJR8GvAIwx0/ggoFwjIcD6Mviy1YKevWHJ1bDLMU98o/J7cNwvXrCuVsYq+EF8kCtvUsnS5NZ6sUt4+RwttQeyVNRD5AAevvmR+gtGdFzTpWt2qZxGnGLv50qy2Ba6TWGsGtWNLxcGY1qiLLHKBNujSdedh6+i07EjaoKPgWR/raF8= nico@esxi-forum"
      ];
      group = "backup";
      path = "/backups/esxi-forum";
      user = "borg";
    };
    esxi-web = {
      authorizedKeys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDWb3ksITQ3csSBnwNQ20xbwk6aSga80OFN1N8MilcpIdHj+T8JkSuma+vumSHcFaAU1esocEEcwLnXbeOnq1WuNF/wohXR1qOiFX9WiSG6imSXvPG4x4sdMqe2iGLxxCx7rtjo7Ty6hmwVNLikuAUraXcnBmruMEQllRWh+hw41Mmrp7RVAXPxZ34qOEySkA3AuiFdefc+z17PIjDWQlCNypNfvNgoDUgFZ/xkgJX5v6mJj286idEARjUFClB9+u1yBBkhyiWdHVEbf3ZEiAX+PNm05/eQ0dTsFKJxNrR94uKNmvidUQiL/HEMpegGR1KtBWmwq4liGWt+k1PjSvGhYs4ceflh+R+OZjLtJGFeaLK7JEwrYFXtkr+MF4NwGdDuvNhUScDqEPm0Oab1b38FrHRZxS6tA2q8p1fAn0gs4+5C8oM9yXgsBNoG4QX7EBqG2V79siNZ6C66NJRLzlPGqwardKS7+ZR+QTOdoLa/LGHOUWbpZ9sD8K6hAIb/tVE= nico@esxi-web"
      ];
      group = "backup";
      path = "/backups/esxi-web";
      user = "borg";
    };
    esxi-web-two = {
      authorizedKeys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCl4E6Tj7HEdyyHUM5O33INPY4OxZIjxwt12iXKAjKROfecXm4o3skqPMx+ORfMMn02IQyyJ62kvCu+/ZNHBNHHPi7ii6LsIKLB6RCcEfS8ZcyzVw/LXoi2U46aQollzEQoQuJ89ewVFBVFQF3V7RD1uVTdiStWAhv2XGtGGp58L9HlrwUwLhnmPuILn2IsS/uDcuypklWRzACmEjlA/CmKaB9ON0JBOI6kfAygAOLYOWm5ysZYQlMt29qzWoQrxixe0//Vq7rdpLdB/s2qS2O1GvlDxS8puqIlHvy/iQnGUmskPiWnCgVZtlF5stQxUKVpjIaTfL++4100Ac5PCKynDCC6B/BMQHDITjv7LO/aFUHI1q1LeMJnEhhmafOo93mMFqw4IflXeb6RjdVJDvin6pAK7ijatHSC7ZS4Ho75sinLbWV0r8qTd229eJEfGUnjAvlP/Eo2+LdWpBDYfqWgqJfIV0rBFENdUfvekLkws9C2ASjNswZ0124ZWwIFwSM= nico@esxi-web-two"
      ];
      group = "backup";
      path = "/backups/esxi-web-two";
      user = "borg";
    };
    web-dragon = {
      authorizedKeys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDK+o9S0fmC5zqV24hVgOWKmDVW18S/FTaIGnLtHFF5dHgGmwCsyv/ERFfG5cHv7obMNWV5mrHXIHMTEvowO1r0RzWWy8gMwfoQkhXvohXdMMZXy7jslnYfYWuLxCV//ZvL+0jy6Q8Sidi/yA49jTYYf4pO86lgxKTXTWS/aIXwRn7UY+CDA1u0T6RtonwGwx18hHkMhqb1QgyFpSgT9bgZO7tfaOwr3KvPwk3XbCozYUsPKLKmDXayIivdGPedDWRmJrZd2rUBDVHGHMFvGv8si1xGTCp7ockTsXKLfOVVeiCv6pV2/Nn/Ky0jvrGeLQmqchzK/NkBsLymsH2TX+XmiyEzm1fwtSWG4zG659R0wphzo+g4jMWIqyVb7x2kRTTY2lDC6r5dhWkSemhSI/J5t96mr03cpT14qpVRE8YjL1VqMuw5d6yq++OMF7o183xD3e3s3E2OzY/3DyDtAA5tWKlVg2dNAiO+1YZsDaoLGn5GQeGXgLBjCM2AzPRma+E="
      ];
      group = "backup";
      path = "/backups/web-dragon";
      user = "borg";
    };
    sgs-artwork = {
      allowSubRepos = true;
      authorizedKeys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDxBY8TX0iEQkf3Bym+3XVlrk8OLOwHOrj7Uy+WxjncOkkutyZ1WsY9liF4j9yjptyQG7Lx8OM8q44NE6+Rk1OXJXMF7CZ4Jq/WvMVnh2zKyNnF8wHBcspsAdG90wCxo6OmNpnY/rRRlNwwnore7raF2PrERtSlsEvLsUgvspYQ8cnLwerJP43QeETlpE1oR0FrbXWQet0I63Ky6UDEp07x0yee21VHnAG74rjGeFGwJBmCPSxnfGVNhCaR0zyu9+hh222liBrlilYm8nqLlsYGZCXiVdOxXJbBy89EVpHds7Lutf+TAYwsPGZf7U4k+g2Jx8N0JHXyzVZa0zS+I48+tqBBflEOqU9oEfGuz4cU/qWys5soLcRX2p9td+RF3OEdBKlTW4UYsINJUri6QSEUrsGaXqQZy8Ds2FBdUpb4pmFVlo9+4qRouiI80a5xVa7a1E5eS5xK5BzWH4fNg5SqtT5L9i2i1ocZp7FA0oa+ixnXNiC1umPZaY/9s+5fh1s="
      ];
      group = "backup";
      path = "/backups/sgs-artwork";
      user = "borg";
    };
  };

  # Set borg user home to prevent prune failures (would otherwise fail due to being located in /var/empty w/o rw permissions)
  users.users.borg.home = "/backups";

  # Create a backup group to allow rsync'ing backups to offsite locations
  users.groups.backup = { members = [ "sgs" "nico" ]; };

  # Borg applies 0600 permissions on repositories by default, it needs to be at least
  # accessible by the backup group though in order for offsite backups to succeed
  # this might not be a fancy solution but works for now
  systemd.services.borg-repo-permissions = {
    serviceConfig.Type = "oneshot";
    script = ''
      find /backups -type d -exec chmod -v 770 {} \;
      find /backups -type f -exec chmod -v 660 {} \;
    '';
  };
  systemd.timers.borg-repo-permissions = {
    wantedBy = [ "timers.target" ];
    timerConfig.OnCalendar = [ "hourly" ];
  };
  # Regularly compacting the repo seems to be required in order for repos to not grow indefinitely in size
  systemd.services.borg-repo-compact = {
    path = [ pkgs.borgbackup ];
    serviceConfig.Type = "oneshot";
    script = ''
      cd /backups
      for folder in $(ls); do
        pushd $folder
          if [ $folder == sgs-artwork ]; then
            for artwork in $(ls); do
              pushd $artwork
                borg compact .
              popd
            done
          else borg compact .
          fi
        popd
      done
    '';
    serviceConfig = {
      User = "borg";
      Group = "backup";
    };
  };
  systemd.timers.borg-repo-compact = {
    wantedBy = [ "timers.target" ];
    timerConfig.OnCalendar = [ "daily" ];
  };

  # Sync repos to our offsite backup storage
  systemd.services.offsite-replication = {
    path = [ pkgs.rsync pkgs.openssh ];
    serviceConfig.Type = "oneshot";
    script = ''
      rsync -e "ssh -i ${garuda-lib.secrets.ssh.team.private}" \
       -avz --delete --progress /backups/ u342919@u342919.your-storagebox.de:/
    '';
    serviceConfig = {
      User = "borg";
      Group = "backup";
    };
  };
  systemd.timers.offsite-replication = {
    wantedBy = [ "timers.target" ];
    timerConfig.OnCalendar = [ "daily" ];
  };

  system.stateVersion = "22.05";
}
