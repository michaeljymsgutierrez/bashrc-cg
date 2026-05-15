## Prerequisites

- **[Git](https://git-scm.com/downloads)** | _Version Control_
  The industry standard for tracking code changes and collaborating.
- **Zsh** | _Terminal Shell_
  The default command-line interface for macOS; manages file execution and scripts.
- **[NVM](https://github.com/nvm-sh/nvm)** | _Node Version Manager_
  Enables seamless switching between different Node.js versions for various projects.
- **[Homebrew](https://brew.sh/)** | _Package Manager_
  Simplifies the installation and management of software and utilities from the terminal.

## Installation

List of required tools and packages:

| NAME                 |  VERSION |
| :------------------- | -------: |
| ghostty              |    1.2.0 |
| ripgrep              |   15.1.0 |
| nvim                 |   0.10.2 |
| tmux                 |      3.4 |
| jq                   |    1.8.1 |
| node                 | 20.19.14 |
| npm                  |   11.5.2 |
| @google/gemini-cli   |   0.39.0 |
| @googleworkspace/cli |   0.22.5 |
| corepack             |   0.32.0 |
| dts-generator        |    3.0.0 |
| http-server          |   14.1.1 |
| jsdoc-to-markdown    |    9.1.2 |
| jsdoc                |    4.0.4 |
| pdf2json             |    3.2.0 |
| prettier             |    3.6.2 |
| typescript           |    5.9.2 |
| yarn                 |  1.22.22 |

## Configuration

Steps to configure Zsh, Ghostty, Neovim, Lazy, Prettier, and Tmux.

### 1. Clone the Configuration Repository

```bash
cd ~/ && git clone git@github.com:michaeljymsgutierrez/bashrc-cg.git

```

### 2. Install fzf (Optional)

```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

```

### 3. Configure Zsh

Add to `~/.zshrc`:

```bash
source ~/bashrc-cg/path.cgf
source ~/bashrc-cg/prompt.cgf
source ~/bashrc-cg/alias.cgf

```

### 4. Configure Ghostty

Add to `~/.config/ghostty/config`:

```bash
config-file = "~/bashrc-cg/ghostty.cgf"

```

### 5. Configure Neovim

Add to `~/.config/nvim/init.lua`:

```lua
local homeDirectory = os.getenv('HOME') .. '/bashrc-cg/nvim-cgf.lua'
local initNvimConfig = loadfile(homeDirectory)
if initNvimConfig then initNvimConfig() end

```

### 6. Configure Tmux

Add to `~/.tmux.conf`:

```bash
source ~/bashrc-cg/tmux.cgf

```

### 7. Global Tooling Configs

```bash
cat ~/bashrc-cg/prettier.cgf > ~/.prettierrc
cat ~/bashrc-cg/lazy-lock.cgf > ~/.config/nvim/lazy-lock.json

```

## Finalize and Restart

```bash
source ~/.zshrc # Apply Zsh changes
nvim            # Launch Neovim

```
