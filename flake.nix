{
  description = "WhiteSur macOS-like theming for NixOS - comprehensive GTK and GNOME configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      allSystems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
    in
    flake-utils.lib.eachSystem allSystems (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          name = "whitesur-config-dev";
          packages = with pkgs; [
            nixpkgs-fmt
            statix
            nix-doc
          ];
        };
      }
    ) // {
      # NixOS system module
      nixosModules.default = import ./modules/nixos/default.nix;
      nixosModules.gnome = import ./modules/nixos/gnome.nix;
      nixosModules.fonts = import ./modules/nixos/fonts.nix;

      # Home Manager modules
      homeManagerModules.default = import ./modules/home-manager/default.nix;
      homeManagerModules.gnome = import ./modules/home-manager/gnome.nix;
      homeManagerModules.gtk = import ./modules/home-manager/gtk.nix;
    };
}
