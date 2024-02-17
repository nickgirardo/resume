{
  description = "Nick's Resume :)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-23.11";
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, gitignore }:
    let
      supportedSystems = ["x86_64-linux" "aarch64-linux"];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      drv = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          tex = pkgs.texlive.combine {
              inherit (pkgs.texlive) scheme-full latex-bin latexmk;
          };
          buildInputs = [ pkgs.coreutils tex ];
          lastUpdatedDate = "2021-11-30";
        in
            pkgs.stdenvNoCC.mkDerivation {
              name = "resume";
              src = gitignore.lib.gitignoreSource ./.;
              inherit buildInputs;
              phases = [ "unpackPhase" "buildPhase" "installPhase" ];
              buildPhase = ''
                  export PATH="${pkgs.lib.makeBinPath buildInputs}";

                  # NOTE this variable is used as the current timestamp by TeX
                  # It is used to print the last updated date in the document's footer
                  export SOURCE_DATE_EPOCH="$(date -d ${lastUpdatedDate} +%s)";

                  mkdir -p .cache/texmf-var
                  env TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var \
                    latexmk -interaction=nonstopmode -pdf -lualatex \
                    resume.tex
                '';
                installPhase = ''
                  mkdir -p $out/dist/
                  cp resume.pdf $out/dist/
                '';
            }
      );
    in
      {
        packages = forAllSystems (system:  {
          default = drv.${system};
          resume = drv.${system};
        });
      };
}
