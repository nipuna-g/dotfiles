{ pkgs, lib, ... }:

# VS Code rather than VSCodium: the Dev Containers extension is proprietary,
# ships only on the MS marketplace (not Open VSX), and the server it injects
# into the container is licensed for official builds only -- so devcontainers
# need the real thing. Linux only; the darwin host gets VS Code as a cask.
lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
  programs.vscode = {
    enable = true;

    # Keep ~/.vscode/extensions writable so marketplace installs still work;
    # only the extensions listed here are managed by Nix. Settings are left
    # alone entirely -- home-manager never writes settings.json.
    mutableExtensionsDir = true;

    profiles.default.extensions = with pkgs.vscode-extensions; [
      ms-vscode-remote.remote-containers
    ];
  };
}
