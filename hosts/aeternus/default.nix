{
    pkgs,
    lib,
    ...
}:
{
    imports = [
        ./hardware-configuration.nix
        ./disks.nix
    ];

    programs.neovim = {
        enable = true;
        defaultEditor = true;
    };

    programs.kdeconnect.enable = true;

    services  = {
    };

    roles = {
    };


    # Boot
    boot = {
        kernelPackages = pkgs.linuxPackages_latest;
        supportedFilesystems = [ "btrfs" ];
        loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
        };
    };

    # Filesystems
    fileSystems = {
        "/".options = [ "compress=zstd" "noatime" ];
        "/home".options = [ "compress=zstd" "noatime" ];
        "/nix".options = [ "compress=zstd" "noatime" ];
        "/persist".options = [ "compress=zstd" "noatime" ];
        "/var/log" = {
            options = [ "compress=zstd" "noatime"];
            neededForBoot = true;
        };
    };

    # Hardware
    hardware = {
        enableAllFirmware = true;
        graphics.enable = true;
        nvidia = {
            modesetting.enable = true;
            powerManagement.enable = true;

            open = true;
            nvidiaSettings = true;
            forceFullCompositionPipeline = true;

            package = config.boot.kernelPackages.nvidiaPackages.stable;
        };
    };

    # Nixpkgs
    nixpkgs = {
        config.allowUnfree = true;
    };

    # Nix
    nix = {
        settings = {
            experimental-features = ["nix-command" "flakes"];
        };
    };

    # Networking
    networking = {
        hostName = "aeternus";
        networkmanager.enable = true;
    };

    # Programs
    programs = {
        firefox.enable = true;
    };

    # Services
    services = {
        xserver = {
            enable = true;
            videoDrivers = ["nvidia"];
        };

        displayManager.sddm.enable = true;
        desktopManager.plasma6.enable = true;
    };

    # Users
    users = {
        users.cosmatrexis = {
            isNormalUser = true;
            extraGroups = [ "wheel" ];
        };
    };

    # Time
    time.timeZone = "America/New_York";

    # International
    i18n.defaultLocale = "en_US.UTF-8";

    console = {
        font = "Lat2-Terminus32";
    };

    system.stateVersion = "25.05";
}
