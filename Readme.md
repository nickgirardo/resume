
Template: [Classicthesis-Styled CV](https://www.latextemplates.com/template/classicthesis-styled-cv)


### Building
Run `pdflatex resume.tex`.  This will output `resume.pdf` as well as several log files.

Alternatively, Nix can manage building.  Run `nix build` on a system with Nix installed.  `flake.nix` describes the build.

### Note on dates
This document makes use of the current date to place a "Last Updated" date in the footer.  Dates are handled slightly differently based on how the document is built.  If using `pdflatex` the current timestamp is used by default.  Nix, however, attempts to hide the current timestamp from the build process to help ensure reproducibility.  Instead we can directly control the date used by TeX with the environment variable `$SOURCE_DATE_EPOCH`.

In `flake.nix`, a value `lastUpdatedDate` is set which (using the unix `date` utility) is converted to a timestamp and used for `$SOURCE_DATE_EPOCH`.
