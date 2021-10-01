#!/bin/zsh
#
# List of Vim plugins.

plugins=(airline airline_themes flattened nerdtree tagbar gutentags fugitive \
	commentary surround gitgutter ale ctrlp )


# Array=("GitHub repository" "local Vim plugin folder" "Make Vim docs")

# Statusline
airline=("vim-airline/vim-airline" "statusline/start/airline" true)
airline_themes=("vim-airline/vim-airline-themes" \
	"statusline/start/airline-themes" true)

# Themes
flattened=("romainl/flattened" "themes/opt/flattened" false)

# IDE
nerdtree=("scrooloose/nerdtree" "ide/start/nerdtree" true)
tagbar=("majutsushi/tagbar" "ide/start/tagbar" true)
gutentags=("ludovicchabant/vim-gutentags" "ide/start/gutentags" true)
fugitive=("tpope/vim-fugitive" "ide/start/fugitive" true)
commentary=("tpope/vim-commentary" "ide/start/commentary" true)
surround=("tpope/vim-surround" "ide/start/surround" true)
gitgutter=("airblade/vim-gitgutter" "ide/start/gitgutter" true)
ale=("dense-analysis/ale" "ide/start/ale" true)
ctrlp=("ctrlpvim/ctrlp.vim" "ide/opt/ctrlp" true)
