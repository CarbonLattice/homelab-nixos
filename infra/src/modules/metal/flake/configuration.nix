{ modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/all-hardware.nix")
    ./disks.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [ "admin" ];
  };
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # The nodes are old PCs with 2016-2019 BIOS firmware: load current CPU microcode at boot.
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;

  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
    openssh.authorizedKeys.keyFiles = [ ./authorized_keys ];
  };
  users.users.root.openssh.authorizedKeys.keyFiles = [ ./authorized_keys ];

  system.stateVersion = "25.05";
}
