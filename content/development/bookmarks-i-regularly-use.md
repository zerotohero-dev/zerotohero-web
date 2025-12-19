+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Development Environment Setup Quickstart Reference"
date = "2025-12-03"

[taxonomies]
tags = ["inbox", "development", "draft"]
+++

Here are some bookmarks that I visit frequently when deploying a new system, 
or setting up a new development environment, or just trying to look something 
up, along with some snippets that I use frequently.

## Build Essentials

```bash
sudo apt update
sudo apt upgrade
sudo apt install build-essential
```

## `~/.zshrc`

```bash
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

source $ZSH/oh-my-zsh.sh

export MANPATH="/usr/local/man:$MANPATH"
export PATH="$PATH:/usr/local/go/bin"
export GPG_TTY=$(tty)
export WORKSPACE="$HOME/WORKSPACE"
export PATH="$PATH:$WORKSPACE/spire/bin"
export PATH="$PATH:$WORKSPACE/spike"
export PATH="$PATH:$HOME/.local/bin"
source "$WORKSPACE/spike/hack/lib/env.sh"
```

## Distro Information

```bash
cat /etc/*release

# Or:
lsb_release -a

## Or:
export ARCH=$(case $(uname -m) in x86_64) \
  echo -n amd64 ;; aarch64) echo -n arm64 ;; *) \
  echo -n $(uname -m) ;; esac)
export OS=$(uname | awk '{print tolower($0)}')
```

## NPM and Node

* [Node.js](https://nodejs.org)

## Claude Code

* [Claude Code](https://claude.com/product/claude-code)

## Grammarly

* [Grammarly](https://www.grammarly.com/)

## GitHub

* [Generating a new SSH Key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
* [Adding a new SSH Key to Your GitHub Account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)
* [Generating a new GPG Key](https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key)
* [Adding a GPG Key to Your GitHub Account](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account)

## Docker

* [Installing Docker Engine to Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
* [Linux Post-Installation Steps for Docker](https://docs.docker.com/engine/install/linux-postinstall/)

## Windows Subsystem for Linux

* [Installing WSL](https://learn.microsoft.com/en-us/windows/wsl/install\)

## Minikube

* [Installing Minikube](https://minikube.sigs.k8s.io/docs/start/)

## Copying SSH Keys to Remote Hosts

```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub user@host
```

## zsh and PowerLevel10k

```bash
sudo apt update
sudo apt install zsh
chsh -s /usr/bin/zsh
```

* [Oh My ZSH](https://ohmyz.sh/)
* [Powerlevel10k](https://github.com/romkatv/powerlevel10k)

## JetBrains

* [JetBrains Toolbox](https://www.jetbrains.com/toolbox-app/)

## Fonts

* [MonoLisa](https://www.monolisa.dev/)
* [PragmataPro Mono](https://fsd.it/shop/fonts/pragmatapro/)
* [Berkeley Mono](https://usgraphics.com/products/berkeley-mono)
* [Operator Mono](https://www.typography.com/fonts/operator/styles/operatormonoscreensmart)

## Themes

* [Gerry Themes](https://plugins.jetbrains.com/plugin/26472-gerry-themes-pro-lifetime-)
* [Dracula Pro](https://draculatheme.com/pro)
* [Monokai Pro](https://monokai.pro/)

## Vim Setup

* [NerdTree](https://github.com/preservim/nerdtree)
* [Gruvbox Theme](https://github.com/morhetz/gruvbox)
* [Vim Airline](https://github.com/vim-airline/vim-airline)

### `.vimrc`

```text
set nocompatible
filetype off

syntax enable
colorscheme darcula
set nu
set rnu
set cursorline

# Right Margin
set colorcolumn=80
highlight colorcolumn guibg=#444444

# Tab Settings
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smarttab
set expandtab

# Remove Scrollbars
set guioptions-=r
set guioptions-=R
set guioptions-=L
set guioptions-=l

set laststatus=2
set hlsearch

# IndentGuidesEnable
autocmd! GUIEnter * set vb t_vb=
```

## Windows

* [Windows Terminal](https://learn.microsoft.com/en-us/windows/terminal/install)
* [Power Toys](https://learn.microsoft.com/en-us/windows/powertoys/)

## Windows Shortcuts

* Next/Previous Desktop: `Win + Ctrl + (right or left arrow key)`
* Shift+Drag to move a window to a fancy zone.

## JetBrains Shortcuts

* Search Everywhere: `Shift + Shift`
* Search in file: `Alt + F3`
* Find in files: `Ctrl + Shift + F`
* Select in...: `Alt + F1`
* Toggle terminal: `Alt + F12`
* Various views: `Alt 1--9`
* Commit view: `Alt + 0`