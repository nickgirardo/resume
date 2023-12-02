{
  description = "Nick's Resume :)";

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      tex = pkgs.texlive.combine {
          inherit (pkgs.texlive) scheme-full latex-bin latexmk;
      };
      buildInputs = [ pkgs.coreutils tex ];
      lastUpdatedDate = "2021-11-30";
      in
    {
      packages.x86_64-linux.default = pkgs.stdenvNoCC.mkDerivation {
        name = "resume";
        src = self;
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
            mkdir -p $out
            cp resume.pdf $out/
          '';
        };
      };
}
