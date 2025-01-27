# Installation

## Prerequisites

- Git installed on your system
- Zsh, Vim, and Tmux installed on your system (installation instructions below)

---

## Step 1: Clone `bashrc-cg` Repository

### Bash

```bash
cd ~/ && git clone git@github.com:michaeljymsgutierrez/bashrc-cg.git
```

````

---

## Step 2: Install `fzf`

### Bash

```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

---

## Step 3: Install Required Software

### Linux

#### Bash

```bash
sudo apt install tmux vim vim-gtk3 fonts-powerline
```

### macOS (using Homebrew)

#### Bash

```bash
brew install vim nvim tmux ripgrep
```

---

## Step 4: Configure Zsh

Add the following lines to your `~/.zshrc` file:

#### Bash

```bash
source ~/bashrc-cg/path.cgf
source ~/bashrc-cg/prompt.cgf
source ~/bashrc-cg/alias.cgf
```

---

## Step 5: Configure Vim

Add the following line to your `~/.vimrc` file:

#### Bash

```bash
source ~/bashrc-cg/vim.cgf
```

---

## Step 6: Configure Neovim

Add the following lines to your `~/.config/nvim/init.lua` file:

#### Lua

```lua
local homeDirectory = os.getenv('HOME') .. '/bashrc-cg/nvim-cgf.lua'
local initNvimConfig = loadfile(homeDirectory)
initNvimConfig()
```

---

## Step 7: Configure Tmux

Add the following line to your `~/.tmux.conf` file:

#### Bash

```bash
source ~/bashrc-cg/tmux.cgf
```

---

## Step 8: Restart and Finalize

Restart your terminal or run the following commands:

#### Bash

```bash
src
# For vim
vim -c "PluginInstall"

# For nvim
nvim
```

```

Let me know if you’d like to add or adjust anything!
```
````
