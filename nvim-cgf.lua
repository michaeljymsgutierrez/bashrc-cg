-- SETUP
-- Copy this lines to ~/.config/nvim/init.lua
-- local homeDir = os.getenv('HOME') .. '/bashrc-cg/nvim-cgf.lua'
-- local initNvimConfig = loadfile(homeDir)
-- initNvimConfig()

-- INITIAL CONFIG
vim.cmd('set number')
vim.cmd('set number')
vim.cmd('set nocompatible')
vim.cmd('set tabstop=2')
vim.cmd('set shiftwidth=2')
vim.cmd('set expandtab')
vim.cmd('set showmatch')
vim.cmd('set t_Co=256')
vim.cmd('set laststatus=2')
vim.cmd('set hlsearch')
vim.cmd('set incsearch')
vim.cmd('set ignorecase')
vim.cmd('set smartcase')
vim.cmd('set wildignore+=*.swp')
vim.cmd('set mouse=a')
vim.cmd('set clipboard+=unnamed')
vim.cmd('set timeoutlen=1000')
vim.cmd('set ttimeoutlen=0')
vim.cmd('set backspace=indent,eol,start')
vim.cmd('set noshowmode')
vim.cmd('set background=dark')
vim.cmd('syntax enable')
vim.cmd('filetype off')
vim.cmd('filetype plugin indent on')

-- PLUGIN MANAGER
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})

    vim.fn.getchar()

    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

-- LAZY PLUGINS
require('lazy').setup({
  spec = {
    {
      'loctvl842/monokai-pro.nvim',
      config = function()
        vim.cmd('colorscheme monokai-pro')
      end
    },
    {
      'preservim/nerdtree',
      config = function()
        vim.cmd('let NERDTreeShowHidden = 1')
        vim.cmd('let NERDTreeRespectWildIgnore = 1')
      end
    },
    {
      'tomtom/tcomment_vim'
    },
    {
      'Yggdroot/indentLine',
      config = function()
        vim.cmd("let g:indentLine_char = '│'")
      end
    }
  },
  install = {
    colorscheme = {
      'monokai-pro'
    }
  },
  checker = { enabled = false },
})

-- KEYBOARD MAPPING CONFIG
vim.api.nvim_set_keymap('n', '<C-Left>', ':tabprevious<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-Right>', ':tabnext<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-T>', ':tabnew<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-F>', ':FZF<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-N>', ':NERDTreeToggle<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-L>', ':NERDTreeFind<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-P>', ':Prettier<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-E>', ':e!<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-X>', ':x<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-O>', ':w<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '|', ':vsplit<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '_', ':split<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-K>', ':Gist -l<CR>', { noremap = true })

vim.api.nvim_set_keymap('v', '<C-U>', ':s/_\\(\\l\\)/\\u\\1/g<CR>', { noremap = true })
vim.api.nvim_set_keymap('v', '<C-D>', ':s/-\\(\\l\\)/\\u\\1/g<CR>', { noremap = true })
vim.api.nvim_set_keymap('v', '<S-U>', ':s/\\(\\l\\)\\(\\u\\)/\\1_\\l\\2/g<CR>', { noremap = true })
vim.api.nvim_set_keymap('v', '<S-D>', ':s/\\(\\l\\)\\(\\u\\)/\\1-\\l\\2/g<CR>', { noremap = true })


