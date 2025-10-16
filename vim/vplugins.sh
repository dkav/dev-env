#!/bin/zsh
#
# List of Vim plugins.

plugins=(airline airline_themes \
  flattened \
  ale commentary fugitive fzf gitgutter gutentags nerdtree surround \
  tagbar)


# Array=("GitHub repository" "local Vim plugin folder" "Make Vim docs")

# Statusline
airline=("vim-airline/vim-airline" "statusline/start/airline" true)
airline_themes=("vim-airline/vim-airline-themes" \
  "statusline/start/airline-themes" true)

# Themes
flattened=("romainl/flattened" "themes/opt/flattened" false)

# IDE
ale=("dense-analysis/ale" "ide/start/ale" true)
commentary=("tpope/vim-commentary" "ide/start/commentary" true)
fugitive=("tpope/vim-fugitive" "ide/start/fugitive" true)
fzf=("junegunn/fzf.vim" "ide/start/fzf" true)
gitgutter=("airblade/vim-gitgutter" "ide/start/gitgutter" true)
gutentags=("ludovicchabant/vim-gutentags" "ide/start/gutentags" true)
nerdtree=("scrooloose/nerdtree" "ide/start/nerdtree" true)
surround=("tpope/vim-surround" "ide/start/surround" true)
tagbar=("majutsushi/tagbar" "ide/start/tagbar" true)
