-- disable netrw in favour of nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.scrolloff = 0

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true

opt.splitright = true
opt.splitbelow = true

opt.hidden = true
opt.swapfile = false
opt.backup = false
opt.undofile = true

opt.updatetime = 250
opt.timeoutlen = 300

opt.backspace = "indent,eol,start"

opt.wrap = false

-- yaml: 2-space indent
vim.api.nvim_create_autocmd("FileType", {
  pattern = "yaml",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})
