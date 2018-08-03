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
    gnupg dev python ruby node r gdal


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

gpg-agent: hbrew
	$(binstall)

pinentry-mac: hbrew
	$(binstall)

gnupg: gpg gpg-agent pinentry-mac


# Development
git: hbrew
	$(binstall)

bfg: hbrew
	$(binstall)

hub: hbrew
	$(binstall)

ctags: hbrew
	$(binstall)

dos2unix: hbrew
	$(binstall)

dev: git bfg hub ctags dos2unix


# Python
pyenv: hbrew
	$(binstall)

pyenv-virtualenv: hbrew
	$(binstall)

pyenv-pip-migrate: hbrew
	$(binstall)

python: pyenv pyenv-virtualenv pyenv-pip-migrate


# Ruby
rbenv: hbrew
	$(binstall)

ruby-build: hbrew
	$(binstall)

rbenv-default-gems: hbrew
	$(binstall)

ruby: rbenv ruby-build rbenv-default-gems
	@echo 'bundler' >> "$$(brew --prefix rbenv)/default-gems"


# Node
nvm: hbrew
	$(binstall)

node: nvm
	@mkdir -p /usr/local/var/nvm
	@cp $$(brew --prefix nvm)/nvm-exec /usr/local/var/nvm/


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
