{
  inputs = { bazel_4_2_1.url = "github:timothyklim/nixpkgs/bazel-4.2.0"; };

  outputs = { nixpkgs, bazel_4_2_1, ... }:
    let
      system = "x86_64-linux";
      overlays = [
        (final: prev: {
          inherit (import bazel_4_2_1 { inherit system; }) bazel_4;
        })
      ];
      pkgs = import nixpkgs { inherit system overlays; };
    in {
      devShell."${system}" = let
        inherit (pkgs) mkShell bazel_4 jdk11;
        inherit (pkgs.lib) makeLibraryPath;
        inherit (pkgs.stdenv) cc;
      in mkShell {
        nativeBuildInputs = with pkgs; [ bazel_4 jdk11 ];
        shellHook = ''
          export LD_LIBRARY_PATH='${makeLibraryPath [ cc.cc.lib ]}'
        '';
      };
    };
}
