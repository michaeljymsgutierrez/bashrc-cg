#### SHELL IMPORTS using source
---

##### Installation
1. Clone `bashrc-cg`

    ```bash
    cd ~/ && git clone git@github.com:michaeljymsgutierrez/bashrc-cg.git
    ```
2. Install `fzf`

    ```bash
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
    ```
3. Install latest `vim/nvim`, `vundle`, `tmux` `nerd-fonts` and  `powerline-fonts`

    ```bash
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    git clone https://github.com/sheerun/vim-polyglot ~/.vim/bundle/vim-polyglot
    git clone https://github.com/ryanoasis/nerd-fonts.git
    cd nerd-fonts && ./install.sh Meslo

    # Linux specific only
    sudo apt install tmux
    sudo apt install vim
    sudo apt install vim-gtk3
    sudo apt-get install fonts-powerline

    # OSX specific only
    brew install vim
    brew install nvim
    brew install tmux
    brew install ripgrep
    ```
4. Copy and paste these following lines on `~/.zshrc` file

    ```bash
    source ~/bashrc-cg/path.cgf
    source ~/bashrc-cg/powerline.cgf
    source ~/bashrc-cg/alias.cgf
    ```
5. Copy and paste these following lines on `~/.vimrc` file

    ```bash
    source ~/bashrc-cg/vim.cgf
    ```
6. Copy and paste these following lines on `~/.config/nvim/init.lua` file

    ```bash
    local homeDirectory = os.getenv('HOME') .. '/bashrc-cg/nvim-cgf.lua'
    local initNvimConfig = loadfile(homeDirectory)
    initNvimConfig()
    ```
7. Copy and paste these following lines on `~/.tmux.conf` file

    ```bash
    source ~/bashrc-cg/tmux.cgf
    ```
8. Restart your `terminal/terminal-emulator` by closing and reopening it or
    run these commands on your terminal

    ```bash
    src
    # For vim
    vim -c "PluginInstall"

    # For nvim
    nvim
    ```
