{ pkgs, lib, ... }:

{
  # Read-only store symlink: edit here and rebuild, then `aerospace reload-config`.
  xdg.configFile."aerospace/aerospace.toml" = lib.mkIf pkgs.stdenv.isDarwin {
    text = ''
      start-at-login = true

      enable-normalization-flatten-containers = true
      enable-normalization-opposite-orientation-for-nested-containers = true

      default-root-container-layout = 'tiles'
      default-root-container-orientation = 'auto'

      on-focused-monitor-changed = ['move-mouse monitor-lazy-center']

      # Main monitor (the external one, per macOS display settings) gets the
      # home-row workspaces; the laptop screen gets the top-row ones.
      # Laptop-only setups have the laptop as main, so all workspaces land there.
      [workspace-to-monitor-force-assignment]
      A = 'main'
      S = 'main'
      D = 'main'
      F = 'main'
      G = 'main'
      Q = 'secondary'
      W = 'secondary'
      E = 'secondary'
      R = 'secondary'
      T = 'secondary'

      [gaps]
      inner.horizontal = 8
      inner.vertical = 8
      outer.left = 8
      outer.bottom = 8
      outer.top = 8
      outer.right = 8

      [mode.main.binding]
      alt-enter = 'exec-and-forget open -na Ghostty'
      alt-b = 'exec-and-forget open -b org.chromium.Chromium'

      alt-slash = 'layout tiles horizontal vertical'
      alt-comma = 'layout accordion horizontal vertical'
      alt-z = 'fullscreen'

      alt-h = 'focus left'
      alt-j = 'focus down'
      alt-k = 'focus up'
      alt-l = 'focus right'

      alt-shift-h = 'move left'
      alt-shift-j = 'move down'
      alt-shift-k = 'move up'
      alt-shift-l = 'move right'

      alt-minus = 'resize smart -50'
      alt-equal = 'resize smart +50'

      alt-a = 'workspace A'
      alt-s = 'workspace S'
      alt-d = 'workspace D'
      alt-f = 'workspace F'
      alt-g = 'workspace G'
      alt-q = 'workspace Q'
      alt-w = 'workspace W'
      alt-e = 'workspace E'
      alt-r = 'workspace R'
      alt-t = 'workspace T'

      alt-shift-a = 'move-node-to-workspace A'
      alt-shift-s = 'move-node-to-workspace S'
      alt-shift-d = 'move-node-to-workspace D'
      alt-shift-f = 'move-node-to-workspace F'
      alt-shift-g = 'move-node-to-workspace G'
      alt-shift-q = 'move-node-to-workspace Q'
      alt-shift-w = 'move-node-to-workspace W'
      alt-shift-e = 'move-node-to-workspace E'
      alt-shift-r = 'move-node-to-workspace R'
      alt-shift-t = 'move-node-to-workspace T'

      alt-tab = 'workspace-back-and-forth'
      alt-shift-tab = 'move-workspace-to-monitor --wrap-around next'

      alt-shift-semicolon = 'mode service'

      [mode.service.binding]
      esc = ['reload-config', 'mode main']
      r = ['flatten-workspace-tree', 'mode main']
      f = ['layout floating tiling', 'mode main']
      backspace = ['close-all-windows-but-current', 'mode main']

      alt-shift-h = ['join-with left', 'mode main']
      alt-shift-j = ['join-with down', 'mode main']
      alt-shift-k = ['join-with up', 'mode main']
      alt-shift-l = ['join-with right', 'mode main']
    '';
  };
}
