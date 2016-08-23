# Makefile to install Homebrew and Homebrew packages

HBREW = /usr/local/bin/brew
HBAPPS = $(shell brew list --versions)

all:  bash-completion wget exiftool git ruby node

$(HBREW):
	@ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	@ln -s "$(brew --prefix)/Library/Contributions/brew_zsh_completion.zsh" /usr/local/share/zsh/site-functions/_brew
	@echo "brew"
brew: $(HBREW)

bash-completion: brew
ifeq (, $(shell brew list --versions bash-completion))
	@brew install bash-completion
endif

wget: brew
ifeq (, $(shell brew list --versions wget))
	@brew install wget
endif

exiftool: brew
ifeq (, $(shell brew list --versions exiftool))
	@brew install exiftool
endif

git: brew
ifeq (, $(shell brew list --versions git))
	@brew install git gist
endif

python: brew
ifeq (, $(shell brew list --versions pyenv))
	@brew install pyenv pyenv-virtualenv pyenv-pip-migrate
endif

ruby: brew
ifeq (, $(shell brew list --versions ruby-build))
	@brew install rbenv ruby-build rbenv-default-gems
	echo 'bundler' >> "$(brew --prefix rbenv)/default-gems"
endif

node: brew
ifeq (, $(shell brew list --versions nvm))
	@brew install nvm
	@mkdir /usr/local/var/nvm
	@cp $(brew --prefix nvm)/nvm-exec /usr/local/var/nvm/
endif
