{ config, pkgs, ... }:
{
    #boot.loader.systemd-boot.enable = true;
    #boot.loader.efi.canTouchEfiVariables = true;

    services = {
        openssh = {
            enable = true;
            settings.PasswordAuthentication = false;
            settings.KbdInteractiveAuthentication = false;
            settings.PermitRootLogin = "yes";
        };
    };

    users = {
        users.root = {
            initialPassword = "";
            openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILlrXoJEmDX/hi1wvH3M2NNYm2saKxrC+ELNyt3v1pBI griffin@cool-laptop" ];
        };

        mutableUsers = false;
    };

    environment.systemPackages = with pkgs; [
        cowsay
    ];

    system.stateVersion = "24.05";
}
