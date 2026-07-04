-- Required external installs:
--   brew install --cask font-jetbrains-mono-nerd-font   (Nerd Font for icons)
--   brew install ripgrep                                 (for Telescope live grep)
--   Set iTerm2 font: Settings → Profiles → Text → "JetBrainsMono Nerd Font"

-- Set leader to space. Must come before any <leader>-prefixed keymap.
vim.g.mapleader = " "

local plug_path = vim.fn.stdpath("data") .. "/site/autoload/plug.vim"
if vim.fn.filereadable(plug_path) == 0 then
  vim.fn.system({
    "curl", "-fLo", plug_path, "--create-dirs",
    "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim",
  })
  vim.cmd("autocmd VimEnter * PlugInstall --sync | source $MYVIMRC")
end

local Plug = vim.fn["plug#"]
vim.call("plug#begin")
Plug("EdenEast/nightfox.nvim")
Plug("karb94/neoscroll.nvim")
Plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" })
Plug("nvim-tree/nvim-web-devicons")
Plug("nvim-tree/nvim-tree.lua")
Plug("nvim-lua/plenary.nvim")
Plug("nvim-telescope/telescope.nvim")
Plug("lewis6991/gitsigns.nvim")
Plug("neovim/nvim-lspconfig")
Plug("williamboman/mason.nvim")
Plug("williamboman/mason-lspconfig.nvim")
vim.call("plug#end")

vim.cmd.colorscheme("carbonfox")

vim.opt.clipboard = "unnamedplus"

vim.opt.number = true
vim.opt.relativenumber = true

local ok_neoscroll, neoscroll = pcall(require, "neoscroll")
if ok_neoscroll then neoscroll.setup() end

local ok_ts, ts_configs = pcall(require, "nvim-treesitter.configs")
if ok_ts then
  ts_configs.setup({
    ensure_installed = { "go", "typescript", "javascript", "tsx", "markdown", "lua", "json", "yaml", "html", "css", "python" },
    highlight = { enable = true },
  })
end

local ok_tree, nvim_tree = pcall(require, "nvim-tree")
if ok_tree then
  nvim_tree.setup({
    view = { width = 40 },
  })
end

local ok_telescope, telescope_builtin = pcall(require, "telescope.builtin")
if ok_telescope then
  vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, { desc = "Find files" })
  vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, { desc = "Search in files" })
end

local ok_gitsigns, gitsigns = pcall(require, "gitsigns")
if ok_gitsigns then
  gitsigns.setup({ base = "main" })
end

-- LSP: mason installs servers, lspconfig wires them up.
local ok_mason, mason = pcall(require, "mason")
if ok_mason then mason.setup() end

-- mason-lspconfig auto-enables installed servers via vim.lsp.enable() (nvim 0.11+).
local ok_mlsp, mlsp = pcall(require, "mason-lspconfig")
if ok_mlsp then
  mlsp.setup({ ensure_installed = { "pyright" } })
end

-- nvim 0.11+ native LSP: nvim-lspconfig ships the config in lsp/pyright.lua,
-- which vim.lsp.enable() reads. Replaces the deprecated require('lspconfig') framework.
if vim.lsp and vim.lsp.enable then
  pcall(vim.lsp.enable, "pyright")
end

-- Buffer-local keymaps, set only once an LSP actually attaches.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)           -- signature + docs popup
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)     -- jump to definition
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)     -- list references
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
  end,
})
