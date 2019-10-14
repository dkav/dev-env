# Makefile to install Homebrew and Homebrew packages

# Install via Hombrew
define binstall
	@if [[ "$$(brew list --versions $@)" ]]; then \
		echo "$@ already installed"; \
	else \
		brew install $@ $(1); \
	fi
endef


all:  brew-tools base-tools security dev-tools dev-langs


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
	@brew tap martido/homebrew-graph

cask-repair: hbrew
	@brew tap vitorgalvao/tiny-scripts
	$(binstall)

brew-tools: brew-graph cask-repair


# Base Tools
tmux: hbrew
	$(binstall)

wget: hbrew
	$(binstall)

rsync: hbrew
	$(binstall)

exiftool: hbrew
	$(binstall)

graphviz: hbrew
	$(binstall)

base-tools: tmux wget rsync exiftool graphviz


# Security
gpg: hbrew
	$(binstall)

pinentry-mac: hbrew
	$(binstall)

gnupg: gpg pinentry-mac

security: gnupg


# Development Tools
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

dev-tools: git bfg hub git-sizer ctags dos2unix


# Development Lanaguages
python: hbrew
	$(binstall)
	@../Python/py_dev.sh
	@../Python/py_jupyter.sh

ruby: hbrew
	$(binstall)
	@../Ruby/rb_dev.sh

node: hbrew
	$(binstall)
	@../Node/npm_packages.sh

r: hbrew
	$(call binstall,--with-openblas)

dev-langs: python ruby node r


# Spatial tools
osgeo: hbrew
	@brew tap osgeo/osgeo4mac

osgeo-gdal: osgeo
	$(binstall)
	@brew link -f gdal2

osgeo-gdal-pdf: osgeo-gdal
	$(binstall)

spatial: osgeo osgeo-gdal osgeo-gdal-pdf
