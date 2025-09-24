## Prerequisites

- **Git:** Git is a version control system used for managing code changes. You can find installation instructions for your specific operating system on the official Git website: https://git-scm.com/downloads

- **Terminal Shell:** Most Linux distributions come pre-installed with a terminal shell like Bash. You can also install Zsh as an alternative. Refer to your distribution's documentation for installation instructions.

## Installation (Choose your OS)

**Linux:**

```
sudo apt install tmux vim vim-gtk3
sudo snap install ghostty --classic
```

**MacOS (using Homebrew):**

```
brew install vim nvim tmux ripgrep ghostty
```

## Configuration

The following steps will guide you through configuring Zsh, Ghostty, Vim/Neovim, and Tmux.

### Step 1: Clone `bashrc-cg` Repository

```bash
cd ~/ && git clone git@github.com:michaeljymsgutierrez/bashrc-cg.git
```

### Step 2: Install fzf (Optional but recommended for Zsh)

```bash
git clone --depth 1 [https://github.com/junegunn/fzf.git](https://github.com/junegunn/fzf.git) ~/.fzf
~/.fzf/install
```

### Step 3: Configure Zsh

Add the following lines to your `~/.zshrc` file:

```bash
source ~/bashrc-cg/path.cgf
source ~/bashrc-cg/prompt.cgf
source ~/bashrc-cg/alias.cgf
```

### Step 4: Configure Vim

Add the following line to your `~/.vimrc` file:

```bash
source ~/bashrc-cg/vim.cgf
```

### Step 5: Configure Ghostty

Add the following line to your `~/.config/ghostty/config` file:

```bash
config-file = "~/bashrc-cg/ghostty.cgf"
```

### Step 6: Configure Neovim

Add the following lines to your `~/.config/nvim/init.lua` file:

```lua
local homeDirectory = os.getenv('HOME') .. '/bashrc-cg/nvim-cgf.lua'
local initNvimConfig = loadfile(homeDirectory)
initNvimConfig()
```

### Step 7: Configure Tmux

Add the following line to your `~/.tmux.conf` file:

```
source ~/bashrc-cg/tmux.cgf
```

### Step 8: Restart and Finalize

Restart your terminal or run the following commands:

```bash
source ~/.zshrc  # For Zsh users
vim -c "PluginInstall"  # For Vim users
nvim  # For Neovim users
```
