-- Copy this lines to ~/.config/nvim/init.lua
-- local homeDir = os.getenv("HOME") .. "/bashrc-cg/nvim-cgf.lua"
-- local initNvimConfig = loadfile(homeDir)
-- initNvimConfig()

vim.cmd("set number")
vim.cmd("set number")
vim.cmd("set nocompatible")
vim.cmd("set tabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set expandtab")
vim.cmd("set showmatch")
vim.cmd("set t_Co=256")
vim.cmd("set laststatus=2")
vim.cmd("set hlsearch")
vim.cmd("set incsearch")
vim.cmd("set ignorecase")
vim.cmd("set smartcase")
vim.cmd("set wildignore+=*.swp")
vim.cmd("set mouse=a")
vim.cmd("set clipboard+=unnamed")
vim.cmd("set timeoutlen=1000")
vim.cmd("set ttimeoutlen=0")
vim.cmd("set backspace=indent,eol,start")
vim.cmd("set noshowmode")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

