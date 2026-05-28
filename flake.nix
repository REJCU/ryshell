{
  description = "A Nix flake for ryshell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    # standard systems: x86_64-linux, aarch64-linux, x86_64-darwin, aarch64-darwin
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        # 1. Define the package build recipe
        packages.default = pkgs.stdenv.mkDerivation rec {
          pname = "ryshell";
          version = "0.1.0";

          src = ./.;

          # Add native build-time tools here (like cmake, pkg-config, make)
          nativeBuildInputs = with pkgs; [ 
            # gnumake
            # cmake 
          ];

          # Add runtime dependency libraries here (like openssl, glibc)
          buildInputs = with pkgs; [ ];

          # If the project uses a standard Makefile or CMake, Nix handles 
          # unpackPhase -> configurePhase -> buildPhase -> installPhase automatically.
          # If it needs a custom install command, uncomment and edit below:
          # installPhase = ''
          #   mkdir -p $out/bin
          #   cp ryshell $out/bin/
          # '';

          meta = with pkgs.lib; {
            description = "ryshell application";
            homepage = "https://github.com/REJCU/ryshell";
            license = licenses.mit; # Change to match project license
            platforms = platforms.all;
          };
        };

        # 2. Define a developer environment (triggered via `nix develop`)
        devShells.default = pkgs.mkShell {
          inputsFrom = [ self.packages.${system}.default ];
          packages = with pkgs; [
            # Extra tools for debugging/development
            gdb
            valgrind
          ];
        };
      }) // {
        # 3. Define a NixOS Module to easily integrate ryshell system-wide
        nixosModules.default = { config, lib, pkgs, ... }: 
          let
            cfg = config.programs.ryshell;
          in {
            options.programs.ryshell = {
              enable = lib.mkEnableOption "ryshell config";
              package = lib.mkOption {
                type = lib.types.package;
                default = self.packages.${pkgs.system}.default;
                description = "The ryshell package to install.";
              };
            };

            config = lib.mkIf cfg.enable {
              environment.systemPackages = [ cfg.package ];
              
              # If ryshell is intended to be a login shell, register it:
              # environment.shells = [ "${cfg.package}/bin/ryshell" ];
            };
          };
      };
}
