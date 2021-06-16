{
  description = "Development environment for AWS + Terraform";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/21.05";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, ... }: flake-utils.lib.eachSystem [
    "x86_64-linux" "i686-linux" "aarch64-linux"
  ] (system:
    let pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
    in {
      devShell = pkgs.mkShell.override {stdenv = pkgs.llvmPackages_11.stdenv;} rec {
        name = "aws-dev";
        buildInputs = with pkgs; [
          awscli2
          terraform
        ];

        shellHook = ''
          export PS1="$(echo -e '\uf375') {\[$(tput sgr0)\]\[\033[38;5;228m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]} (${name}) \\$ \[$(tput sgr0)\]"
         '';
      };
    });
}
