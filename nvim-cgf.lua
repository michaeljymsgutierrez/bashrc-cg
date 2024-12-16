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
      'tomtom/tcomment_vim'
    },
    {
      'ntpeters/vim-better-whitespace'
    },
    {
      'mustache/vim-mustache-handlebars'
    },
    {
      'mhinz/vim-signify'
    },
    {
      'nvim-web-devicons'
    },
    {
      'tpope/vim-fugitive'
    },
    {
      'mattn/webapi-vim'
    },
    {
      'mattn/vim-gist',
      config = function()
       vim.cmd('source ~/.vim/.gh-credentials')
       vim.g.gist_username = vim.g.gh_user
       vim.g.gist_token = vim.g.gh_token
      end
    },
    {
      'goolord/alpha-nvim',
      dependencies = {
        'nvim-tree/nvim-web-devicons'
      },
      config = function()
        local startify = require('alpha.themes.startify')
        startify.file_icons.provider = 'devicons'
        require('alpha').setup(
          startify.config
        )
      end
    },
    {
      'navarasu/onedark.nvim',
      config = function()
        require('onedark').setup {
          style = 'warmer' -- dark, darker, cool, deep, warm, warmer, light
        }
        require('onedark').load()
      end
    },
    {
      'nvim-tree/nvim-tree.lua',
      version = "*",
      lazy = false,
      dependencies = {
        'nvim-tree/nvim-web-devicons',
      },
      config = function()
        require('nvim-tree').setup {}
      end,
    },
    {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
      dependencies = {
        'nvim-lua/plenary.nvim'
      }
    },
    {
      'nvim-lualine/lualine.nvim',
      dependencies = {
        'nvim-tree/nvim-web-devicons'
      },
      config = function()
        require('lualine').setup {
          options = {
            section_separators = '',
            component_separators = ''
          }
        }
      end
    },
    {
      'prettier/vim-prettier',
      config = function()
        vim.cmd("let g:prettier#config#semi = 'false'")
        vim.cmd("let g:prettier#config#single_quote = 'true'")
      end
    },
    {
      'Yggdroot/indentLine',
      config = function()
        vim.cmd("let g:indentLine_char = '│'")
      end
    },
    {
      'nvim-treesitter/nvim-treesitter',
      dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
        'nvim-treesitter/playground',
        'nvim-treesitter/nvim-treesitter-context',
        'nvim-treesitter/nvim-treesitter-refactor'
      },
      config = function()
        require('nvim-treesitter.configs').setup({
          ensure_installed = {
            'css', 'scss', 'html', 'javascript', 'typescript', 'json', 'json5', 'jsdoc',
            'markdown', 'vim', 'lua', 'bash', 'yaml', 'go', 'comment'
          },
          highlight = { enable = true },
          indent = { enable = true },
          textobjects = { enable = true }
        })
      end
    },
  },
  install = {},
  checker = { enabled = false },
})

-- FILE ASSOCIATION CONFIG
vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufEnter' }, {
  pattern = { '*.tmux' },
  command = 'set syntax=sh'
})

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufEnter' }, {
  pattern = { '*.cgf' },
  callback = function()
    vim.cmd('set syntax=sh')
    vim.cmd('set ft=sh')
  end
})

-- Check this autocmd if working
-- vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufEnter' }, {
--   pattern = { '*.ts', '*.tsx' },
--   command = 'set syntax=javascript'
-- })

-- KEYBOARD MAPPING CONFIG
vim.api.nvim_set_keymap('n', '<C-Left>', ':tabprevious<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-Right>', ':tabnext<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-T>', ':tabnew<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-F>', ':Telescope find_files<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-N>', ':NvimTreeToggle<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-L>', ':NvimTreeFindFileToggle<CR>', { noremap = true })
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
