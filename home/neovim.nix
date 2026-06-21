{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;
    extraPackages = with pkgs; [
      nixd
      nixfmt
      lua-language-server
      typescript-language-server
      pyright
      rust-analyzer
      fd
    ];
    plugins = with pkgs.vimPlugins; [
      tokyonight-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      plenary-nvim
      telescope-nvim
      telescope-fzf-native-nvim
      (nvim-treesitter.withPlugins (p: with p; [
        nix lua typescript javascript tsx python rust
        json yaml toml markdown html css bash
      ]))
      nvim-web-devicons
      nui-nvim
      neo-tree-nvim
      gitsigns-nvim
      lualine-nvim
      snacks-nvim
      claudecode-nvim
    ];
  };

  xdg.configFile."nvim" = {
    source = ../nvim;
    recursive = true;
  };
}
