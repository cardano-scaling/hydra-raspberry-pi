{
  description = "Example Raspberry Pi 5 configuration flake";
  inputs = {
    hydra.url = "github:cardano-scaling/hydra";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
  };

  nixConfig = {
    extra-substituters = [
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

  outputs = inputs:
    {
      nixosConfigurations = {
        hydraberry = inputs.nixos-raspberrypi.lib.nixosSystem {
          specialArgs = inputs;
          modules = [
            ({ ... }: {
              imports = with inputs.nixos-raspberrypi.nixosModules; [
                raspberry-pi-5.base
                raspberry-pi-5.bluetooth
              ];
            })
            ({ ... }: {
              networking.hostName = "hydraberry";
              users.users.yourUserName = {
                initialPassword = "yourInitialPassword";
                isNormalUser = true;
                extraGroups = [
                  "wheel"
                ];
                environment.systemPackages = [
                  inputs.hydra.packages.aarch64-linux.hydra-node
                ];
              };
            })
          ];
        };
      };
    };
}
