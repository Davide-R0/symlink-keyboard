# TODO: - rimuovere openscad dalle dipendenze
{
  description = "Development environment with OpenSCAD and KiCad (Stable)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      });
    in
    {
      devShells = forAllSystems ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            # 3D
            openscad
            
            # Pcb
            kicad
            
            # General
            git
            graphviz # needed for skidl ?
            entr #for watch files

            # Build tools
            just
            cmake
            ninja
            ccache

            # Compiler for ARM Cortex-M architecture (chip nRF52840 of nice!nano)
            gcc-arm-embedded

            # Device Tree Compiler (for Zephyr)
            dtc
            
            # 3D library needed
            libGL
            #glib
            zlib
            expat
            xorg.libX11
            #xorg.libXext
            xorg.libXrender
            stdenv.cc.cc.lib # Per le librerie C++ standard

            # Python3 and needed packages
            (python312.withPackages (ps: with ps; [
              pip
              west
              pyelftools
              pyyaml
              pyserial
            ]))
          ];

          ZEPHYR_TOOLCHAIN_VARIANT="gnuarmemb";
          GNUARMEMB_TOOLCHAIN_PATH="${pkgs.gcc-arm-embedded}";
          CMAKE_PREFIX_PATH="${pkgs.gcc-arm-embedded}:$CMAKE_PREFIX_PATH";

          # For build123d dependencies?
          LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath (with pkgs; [
            libGL
            #glib #
            zlib
            expat
            xorg.libX11
            #xorg.libXext #
            xorg.libXrender
            stdenv.cc.cc.lib
          ])}:$LD_LIBRARY_PATH";

          shellHook = ''
            echo "--- Environment CAD/EDA loaded ---"
            echo "Python:   $(python --version)"
            echo "OpenSCAD: $(openscad --version 2>&1)"
            echo "KiCad:    OK "
            echo "GCC ARM:  $(arm-none-eabi-gcc --version | head -n 1)"
            echo "West:     $(west --version)"
            if [ ! -d ".venv" ]; then
              echo "Virtual Environment Init in .venv..."
              python -m venv .venv
            fi
            echo "Python venv activation..."
            source .venv/bin/activate
            echo "--------------------------------"
          '';
        };
      });
    };
}
