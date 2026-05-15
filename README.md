## Prerequisites

- **Git:** You'll need Git for version control. You can find installation instructions on the official Git website: [https://git-scm.com/downloads](https://git-scm.com/downloads)
- **Terminal Shell:** This guide uses **Zsh**, which is the default shell on macOS.
- **Homebrew:** This is the package manager for macOS. If you don't have it installed, you can get it from the official Homebrew website: [https://brew.sh/](https://brew.sh/)

---

## Installation

List of tools and packages needed:

| NAME                 | VERSION  |
| :------------------- | :------- |
| ghostty              | 1.2.0    |
| ripgrep              | 15.1.0   |
| nvim                 | 0.10.2   |
| tmux                 | 3.4      |
| jq                   | 1.8.1    |
| nvm                  | 0.39.3   |
| node                 | 20.19.14 |
| npm                  | 11.5.2   |
| @google/gemini-cli   | 0.39.0   |
| @googleworkspace/cli | 0.22.5   |
| corepack             | 0.32.0   |
| dts-generator        | 3.0.0    |
| http-server          | 14.1.1   |
| jsdoc-to-markdown    | 9.1.2    |
| jsdoc                | 4.0.4    |
| pdf2json             | 3.2.0    |
| prettier             | 3.6.2    |
| typescript           | 5.9.2    |
| yarn                 | 1.22.22  |

---

## Configuration

These steps will configure your Zsh, Ghostty, Neovim, Lazy, Prettier and Tmux environments.

### 1\. Clone the Configuration Repository

Navigate to your home directory and clone the configuration repository:

```bash
cd ~/ && git clone git@github.com:michaeljymsgutierrez/bashrc-cg.git
```

### 2\. Install fzf (Optional but Recommended)

**fzf** is a fuzzy finder that helps you quickly search for files and commands. Install it with the following commands:

```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### 3\. Configure Zsh

Add the following lines to your `~/.zshrc` file to load the custom configurations for your command-line environment:

```bash
source ~/bashrc-cg/path.cgf
source ~/bashrc-cg/prompt.cgf
source ~/bashrc-cg/alias.cgf
```

### 4\. Configure Ghostty

Add this line to your `~/.config/ghostty/config` file to load the custom Ghostty configuration:

```bash
config-file = "~/bashrc-cg/ghostty.cgf"
```

### 5\. Configure Neovim

Add the following lines to your `~/.config/nvim/init.lua` file to set up Neovim:

```lua
local homeDirectory = os.getenv('HOME') .. '/bashrc-cg/nvim-cgf.lua'
local initNvimConfig = loadfile(homeDirectory)
initNvimConfig()
```

### 6\. Configure Tmux

Add this line to your `~/.tmux.conf` file to load the custom Tmux configuration:

```bash
source ~/bashrc-cg/tmux.cgf
```

### 7\. Configure Prettier

Execute the following command to install the Prettier configuration:

```bash
cat ~/bashrc-cg/prettier.cgf > ~/.prettierrc
```

### 8\. Configure Lazy

Execute the following command to install the Lazy configuration:

```bash
cat ~/bashrc-cg/lazy.cgf > ~/.config/nvim/lazy-lock.json
```

---

## Finalize and Restart

After making all these changes, restart your terminal or run the commands below to apply the new configurations:

```bash
source ~/.zshrc # Applies Zsh configuration
nvim # Starts Neovim
```
