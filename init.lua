-- Required external installs:
--   brew install --cask font-jetbrains-mono-nerd-font   (Nerd Font for icons)
--   brew install ripgrep                                 (for Telescope live grep)
--   Set iTerm2 font: Settings → Profiles → Text → "JetBrainsMono Nerd Font"

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
    ensure_installed = { "go", "typescript", "javascript", "tsx", "markdown", "lua", "json", "yaml", "html", "css" },
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
  vim.keymap.set("n", "<C-o>", telescope_builtin.find_files, { desc = "Find files" })
  vim.keymap.set("n", "<C-f>", telescope_builtin.live_grep, { desc = "Search in files" })
end
