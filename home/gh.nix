{ pkgs, ... }:

{
  programs.gh = {
    enable = true;

    # Defaults to true. Leaving it on routes git's HTTPS credentials through
    # gh's *active* account, so a `gh auth switch` would silently retarget
    # pushes; osxkeychain stays authoritative instead.
    gitCredentialHelper.enable = false;

    # gh's own git operations (pr create, repo clone) then go over ssh and
    # authenticate with the card, never the credential helper.
    settings.git_protocol = "ssh";

    # Managed as a store symlink, so further extensions belong here too --
    # `gh extension install` cannot write into it.
    extensions = [ pkgs.gh-stack ];
  };
}
