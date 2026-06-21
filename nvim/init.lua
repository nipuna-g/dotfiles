-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.updatetime = 50
vim.opt.signcolumn = "yes"
vim.opt.laststatus = 3

vim.g.mapleader = " "

-- Disable netrw (we use neo-tree on demand)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Theme
require("tokyonight").setup({ style = "night" })
vim.cmd.colorscheme("tokyonight-night")

-- Treesitter (v0.10: enable per-filetype via built-in API)
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

-- Completion
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

-- LSP
vim.lsp.config("*", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})
vim.lsp.enable({ "nixd", "lua_ls", "ts_ls", "pyright", "rust_analyzer" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  end,
})

-- Telescope
local telescope = require("telescope")
telescope.setup()
telescope.load_extension("fzf")

-- Neo-tree
require("neo-tree").setup({
  window = { width = 30 },
  close_if_last_window = true,
  filesystem = {
    hijack_netrw_behavior = "disabled",
  },
})

-- Gitsigns
require("gitsigns").setup()

-- Lualine
require("lualine").setup({
  options = { theme = "tokyonight" },
})

-- Snacks (terminal UI used by claudecode)
require("snacks").setup({})

-- Claude Code
require("claudecode").setup()

-- Keymaps
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]])
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]])
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]])
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]])
vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]])
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")

-- Claude Code keymaps
vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>ClaudeCode<cr>",         { desc = "Claude: toggle" })
vim.keymap.set("n",          "<leader>af", "<cmd>ClaudeCodeFocus<cr>",    { desc = "Claude: focus" })
vim.keymap.set("n",          "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   { desc = "Claude: resume" })
vim.keymap.set("n",          "<leader>aC", "<cmd>ClaudeCode --continue<cr>", { desc = "Claude: continue" })
vim.keymap.set("n",          "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",    { desc = "Claude: add buffer" })
vim.keymap.set("v",          "<leader>as", "<cmd>ClaudeCodeSend<cr>",     { desc = "Claude: send selection" })
vim.keymap.set("n",          "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Claude: accept diff" })
vim.keymap.set("n",          "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   { desc = "Claude: deny diff" })
