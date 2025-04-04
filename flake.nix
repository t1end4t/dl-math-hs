{
  inputs = {
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-python.url = "github:cachix/nixpkgs-python";
    nixpkgs-python.inputs = {
      nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs =
    {
      self,
      nixpkgs,
      devenv,
      systems,
      nixpkgs-unstable,
      ...
    }@inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = forEachSystem (system: {
        devenv-up = self.devShells.${system}.default.config.procfileScript;
      });

      devShells = forEachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
        in
        {
          default = devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [
              {
                packages = with pkgs; [
                  pyright # python lsp
                  ruff # fast linter
                ];

                # https://devenv.sh/reference/options/
                languages.python = {
                  enable = true;
                  version = "3.11";
                  uv = {
                    enable = true;
                    package = pkgs-unstable.uv;
                    sync.enable = true;
                  };
                  # poetry = {
                  #   enable = true;
                  #   install = {
                  #     enable = true;
                  #   };
                  #   activate.enable = true;
                  # };
                };

                # https://devenv.sh/pre-commit-hooks/
                # pre-commit.hooks = {
                #   ruff.enable = true; # linting
                # };
              }
            ];
          };
        }
      );
    };
}
