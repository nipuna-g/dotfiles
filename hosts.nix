# Consumed via specialArgs (host modules) and extraSpecialArgs (home-manager).
let
  local = ./local/hosts-mac.nix;
in
{
  nixos = {
    hostname = "nixos";
    system = "x86_64-linux";
    username = "nipuna";
    homeDirectory = "/home/nipuna";
  };

  # Untracked, so this needs a `path:` flake ref; the default git ref sees only
  # tracked files. Throws rather than falling back, so a wrong ref cannot
  # silently build against the wrong user.
  mac =
    if builtins.pathExists local then
      import local
    else
      throw "local/hosts-mac.nix not found -- rebuild with: darwin-rebuild switch --flake path:$HOME/dotfiles#mac";
}
