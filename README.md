# vim config
My personal vim config. Hosted here so that I can copy and synchronize
it easily onto new devices.

## Requirements

### Lua support

`:echo has("lua")` must return `1`. If not, install a vim version with Lua supports:

#### Debian

```sh
apt install vim vim-nox
```

#### OS X

```sh
brew install vim --with-lua
```

Make sure `/usr/local/bin` is in your `$PATH` **before** `/usr/bin`.

In your `.bash_profile` / `.zshrc` add: `export 'EDITOR=/usr/local/bin/vim'`.

## Install
```sh
git clone https://github.com/julienschmidt/vim.git ~/.vim
ln -s ~/.vim/vimrc ~/.vimrc
cd ~/.vim
git submodule update --init
```

### OS X
```sh
brew install ctags
```

## Update Plugins
```sh
git submodule foreach git pull origin master
```

