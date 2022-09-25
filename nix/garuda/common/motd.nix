{ pkgs, ... }:

{
  # Add fancy MOTD to shell logins
  environment.interactiveShellInit = ''
    ${pkgs.fancy-motd}/bin/motd

    # Own additions
    echo -e ""
    echo -e "                 Please behave well and have fun! 🦅               "
    echo -e "         In case of issues or questions contact Nico or TNE.       "
    sleep 3
  '';
}
