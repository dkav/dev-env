# Makefile to install Homebrew and Homebrew packages

# Install via Hombrew
define binstall
	@if [[ "$$(brew list --versions $@)" ]]; then \
		echo "$@ already installed"; \
	else \
		brew install $@ $(1); \
	fi
endef


all:  brew-tools bash-completion wget rsync exiftool graphviz \
    gnupg python ruby node r gdal


# Install Homebrew if it is not installed
hbrew:
    ifeq ($(shell which brew),)
	    @echo "Installing Homebrew"
	    @ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	    @ln -fs "$$(brew --prefix)/Library/Contributions/brew_zsh_completion.zsh" /usr/local/share/zsh/site-functions/_brew
    endif


# Homebrew Packages
# =================

# Brew Tools
brew-graph: hbrew
	@brew tap martido/brew-graph
	$(binstall)

cask-repair: hbrew
	@brew tap vitorgalvao/tiny-scripts
	$(binstall)

brew-tools: brew-graph cask-repair


# Base Tools
bash-completion: hbrew
	$(binstall)

wget: hbrew
	$(binstall)

rsync: hbrew
	$(binstall)

exiftool: hbrew
	$(binstall)

graphviz: hbrew
	$(binstall)


# GnuPG
gpg: hbrew
	$(binstall)

pinentry-mac: hbrew
	$(binstall)

gnupg: gpg pinentry-mac


# Development
git: hbrew
	$(binstall)

bfg: hbrew
	$(binstall)

hub: hbrew
	$(binstall)

git-sizer: hbrew
	$(binstall)

universal-ctags: hbrew
	@brew tap universal-ctags/universal-ctags
	$(binstall) --HEAD

dos2unix: hbrew
	$(binstall)

dev: git bfg hub git-sizer ctags dos2unix


# Python
python: hbrew
	$(binstall)
	@../Python/py_dev.sh
	@../Python/py_jupyter.sh


# Ruby
ruby: hbrew	
	$(binstall)
	@gem install -f bundler


# Node
node: hbrew
	$(binstall)
	@../Node/npm_packages.sh


# R
r: hbrew
	$(call binstall,--with-openblas)


# GDAL
osgeo: hbrew
	@brew tap osgeo/osgeo4mac

gdal2: osgeo
	$(binstall)
	@brew link -f gdal2

gdal2-pdf: gdal2
	$(binstall)

gdal: gdal2-pdf
