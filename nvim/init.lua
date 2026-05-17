-- Options
vim.opt.number = true          -- line numbers
vim.opt.relativenumber = true  -- relative line numbers
vim.opt.tabstop = 2            -- 2 space tabs
vim.opt.shiftwidth = 2
vim.opt.expandtab = true       -- spaces not tabs
vim.opt.smartindent = true
vim.opt.wrap = false           -- no line wrap
vim.opt.mouse = "a"            -- mouse support
vim.opt.clipboard = "unnamedplus"  -- use system clipboard
vim.opt.termguicolors = true   -- full color support
vim.opt.scrolloff = 8          -- keep 8 lines above/below cursor
vim.opt.updatetime = 50        -- faster updates
vim.opt.signcolumn = "yes"     -- always show sign column

-- Leader key
vim.g.mapleader = " "

-- Keymaps
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)           -- file explorer
vim.keymap.set("n", "<C-d>", "<C-d>zz")               -- center on scroll down
vim.keymap.set("n", "<C-u>", "<C-u>zz")               -- center on scroll up
vim.keymap.set("n", "<leader>y", '"+y')                -- yank to system clipboard
vim.keymap.set("v", "<leader>y", '"+y')

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins (empty for now)
require("lazy").setup({
  -- Theme
  {
    "folke/tokyonight.nvim",
    priority = 1000,  -- load before other plugins
    config = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config("nixd", {})
      vim.lsp.enable("nixd")
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<Tab>"]     = cmp.mapping.select_next_item(),
          ["<S-Tab>"]   = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
})
