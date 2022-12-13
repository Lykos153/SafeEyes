{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {self, nixpkgs, flake-utils, ...}@inputs: 
  let
    recipe =  { python3, fetchFromGitHub, lib }:
      with python3.pkgs;
  
      buildPythonApplication rec {
        name = "safeeyes";
        #version = "2.1.4";

        src = ./.;

        nativeBuildInputs = [
          pkgs.gobject-introspection
          pkgs.wrapGAppsHook
        ];
        
        propagatedBuildInputs = with self; [
          babel
          psutil
          croniter
          pygobject3
          xlib
          dbus-python
          pkgs.alsa-utils
          pkgs.libappindicator-gtk3
          pkgs.xprintidle
          pkgs.wlrctl
          pkgs.gtk3
          pkgs.libnotify
        ];

        meta = {
          description = "Protect your eyes from eye strain using this continuous breaks reminder.";
          homepage = https://github.com/slgobinath/SafeEyes;
          license = lib.licenses.gpl3Only;
        };

      };
  in
  flake-utils.lib.eachDefaultSystem (system: let
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    defaultPackage = pkgs.callPackage recipe {};
  });
}
