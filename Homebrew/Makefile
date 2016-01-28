# Makefile to install Homebrew and Homebrew packages

HBREW = /usr/local/bin/brew
HBAPPS = $(shell brew list --versions)

all: exiftool wget git hg python ruby node

$(HBREW):
	@ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	@sudo ln -s "$(brew --prefix)/Library/Contributions/brew_zsh_completion.zsh" /usr/share/zsh/site-functions/_brew
	@echo "brew"
brew: $(HBREW)

exiftool: brew
ifeq (, $(shell brew list --versions exiftool))
	@brew install exiftool
endif

wget: brew
ifeq (, $(shell brew list --versions wget))
	@brew install wget
endif

git: brew
ifeq (, $(shell brew list --versions git))
	@brew install git
endif

hg: brew
ifeq (, $(shell brew list --versions mercurial))
	@brew install mercurial
endif

python: brew
ifeq (, $(shell brew list --versions pyenv))
	@brew install pyenv pyenv-virtualenv pyenv-pip-migrate
endif

ruby: brew
ifeq (, $(shell brew list --versions ruby-build))
	@brew install ruby-build
	@brew install rbenv rbenv-gemset --HEAD
endif

node: brew
ifeq (, $(shell brew list --versions nvm))
	@brew install nvm
	@mkdir /usr/local/var/nvm
	@cp $(brew --prefix nvm)/nvm-exec /usr/local/var/nvm/
endif
