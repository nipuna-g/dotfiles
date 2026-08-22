{ ... }:

{
  programs.ssh = {
    enable = true;

    # Upstream is removing this module's implicit defaults, so pin them.
    enableDefaultConfig = false;

    # Blocks naming an account here, untracked; see README.
    # Emitted first, which is what gives it precedence, and ssh ignores it if absent.
    includes = [ "~/dotfiles/local/ssh_config" ];

    settings."*" = {
      ForwardAgent = false;
      AddKeysToAgent = "no";
      Compression = false;
      ServerAliveInterval = 0;
      ServerAliveCountMax = 3;
      HashKnownHosts = false;
      UserKnownHostsFile = "~/.ssh/known_hosts";
      ControlMaster = "no";
      ControlPath = "~/.ssh/master-%r@%n:%p";
      ControlPersist = "no";
    };
  };
}
