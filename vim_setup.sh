# Vim Customizations #
#====================#
# Goto dotfiles folder
dotdir=~
rm -frd $dotdir/.vim
autoldir=$dotdir/.vim/autoload
bundledir=$dotdir/.vim/bundle

mkdir -p $autoldir $bundledir

# vim-pathogen
# https://github.com/tpope/vim-pathogen
echo "Installing vim-pathogen"
curl -LSso $autoldir/pathogen.vim https://tpo.pe/pathogen.vim

# vim-airline
echo "Installing vim-airline"
wkdir=$bundledir/vim-airline
git clone https://github.com/bling/vim-airline $wkdir
rm -frd  $wkdir/.git

# vim-colors-solarized
echo "Installing vim-solarized"
wkdir=$bundledir/vim-colors-solarized
git clone git://github.com/altercation/vim-colors-solarized.git $wkdir
rm -frd $wkdir/.git


# vim-fugitive
echo "Installing vim-fugitive"
wkdir=$bundledir/vim-fugitive
git clone git://github.com/tpope/vim-fugitive.git $wkdir
vim -u NONE -c "helptags vim-fugitive/doc" -c q
rm -frd $wkdir/.git


# vim-flake8
echo "Installing vim-flake8"
wkdir=$bundledir/vim-flake8
git clone https://github.com/nvie/vim-flake8.git $wkdir
rm -frd $wkdir/.git

echo "Done"
