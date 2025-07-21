## Nipuna's dotfiles

A bear git repo to hold all my config files.

Following the pattern described here: https://www.atlassian.com/git/tutorials/dotfiles

### Setup

#### Pre-requisites

- Have git installed and ssh setup(if needed)

#### Populate dotfiles

1. Checkout repo to custom directory

```sh
git clone --separate-git-dir=$HOME/.myconf git@github.com:nipuna-g/dotfiles.git
```

2. Setup alias `config` to manage configs

```sh
alias config='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'
```

3. Config to hide untracked files

```sh
config config status.showUntrackedFiles no
```
