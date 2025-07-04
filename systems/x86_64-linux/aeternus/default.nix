{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./disks.nix
    inputs.nixos-facter-modules.nixosModules.facter
    { config.facter.reportPath = ./facter.json; }
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.kdeconnect.enable = true;

  ## services = {
  ##  virtualization.podman.enable = true; # Enable Podman for container management.
  ##  virtualization.kvm.enable = true; # Enable KVM Virtualization support.
  ## };

  roles = {
    common.enable = true; # Enable common configurations.
  };

  boot = {
    plymouth = {
      enable = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = lib.mkForce [ "btrfs" ];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # Hardware
  hardware = {
    enableAllFirmware = true;

    graphics = {
      enable = true;
    };

    # NVidia
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;

      open = true; # Use open source drivers, if available.
      forceFullCompositionPipeline = true; # Force full composition pipeline for better performance.
      nvidiaSettings = true; # Enable nvidia-settings for configuration.

      package = config.boot.kernelPackages.nvidiaPackages.stable; # Use stable NVIDIA drivers.
    };
  };

  /*
    fileSystems = {
      "/".options = [
        "compress=zstd"
        "noatime"
      ];
      "/home".options = [
        "compress=zstd"
        "noatime"
      ];
      "/nix".options = [
        "compress=zstd"
        "noatime"
      ];
      "/persist".options = [
        "compress=zstd"
        "noatime"
      ];
      "/var/log" = {
        options = [
          "compress=zstd"
          "noatime"
        ];
        neededForBoot = true;
      };
    };
  */

  nixpkgs.config.allowUnfree = true;

  # Networking
  networking = {
    hostName = "aeternus";
    networkmanager.enable = true;
  };

  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
    };

    displayManager = {
      sddm.enable = true;
    };

    desktopManager = {
      plasma6.enable = true;
    };
  };

  # Users
  users.users.cosmatrexis = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  #Time
  time.timeZone = "America/New_York";

  # International
  i18n.defaultLocale = "en_US.UTF-8";

  # Console
  console = {
    font = "Lat2-Terminus32";
  };

  # Experimental Features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    curl
    vscode
    nil
    nixfmt-rfc-style
  ];

  system.stateVersion = "25.05";
}
