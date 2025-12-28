{
  description = "My personal NUR repository";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    daeuniverse.url = "github:daeuniverse/flake.nix";
    llm-agents.url = "github:numtide/llm-agents.nix";
  };
  outputs =
    {
      self,
      nixpkgs,
      daeuniverse,
      llm-agents,
    }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
      pkgsOverlays = {
        nixpkgs.overlays = [
          (final: prev: {
            shirok1 = import ./default.nix { pkgs = final; };
            llm-agents = inputs.llm-agents.packages.${final.stdenv.hostPlatform.system};
          })
        ];
      };

      mkSystem = host: nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          pkgsOverlays

          ./machines/${host}/configuration.nix

          inputs.daeuniverse.nixosModules.dae
          inputs.daeuniverse.nixosModules.daed

          self.nixosModules.qbittorrent-clientblocker
          self.nixosModules.snell-server
        ];
      };
    in
    {
      legacyPackages = forAllSystems (
        system:
        import ./default.nix {
          pkgs = import nixpkgs {
            inherit system;
          };
        }
      );
      packages = forAllSystems (
        system: nixpkgs.lib.filterAttrs (_: v: nixpkgs.lib.isDerivation v) self.legacyPackages.${system}
      );
      nixosModules = import ./modules;

      nixosConfigurations.nixo6n = mkSystem "o6n";
      nixosConfigurations.nixopi5 = mkSystem "opi5";
    };
}
