# Makefile to install Homebrew and Homebrew packages

define binstall
	@if [[ "$$(brew list --versions $@)" ]]; then \
		echo "$@ already installed"; \
	else \
		brew install $@; \
	fi
endef

all:  bash-completion wget rsync exiftool gnupg git ctags python ruby node

hbrew:
ifeq ($(shell which brew),)
	@echo "Installing Homebrew"
	@ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	@ln -fs "$$(brew --prefix)/Library/Contributions/brew_zsh_completion.zsh" /usr/local/share/zsh/site-functions/_brew
endif

bash-completion: hbrew
	$(binstall)

wget: hbrew
	$(binstall)

rsync: hbrew
	$(binstall)

exiftool: hbrew
	$(binstall)

gpg: hbrew
	$(binstall)

gpg-agent: hbrew
	$(binstall)

pinentry-mac: hbrew
	$(binstall)

gnupg: gpg gpg-agent pinentry-mac

git: hbrew
	$(binstall)

ctags: hbrew
	$(binstall)

pyenv: hbrew
	$(binstall)

pyenv-virtualenv: hbrew
	$(binstall)

pyenv-pip-migrate: hbrew
	$(binstall)

python: pyenv pyenv-virtualenv pyenv-pip-migrate

rbenv: hbrew
	$(binstall)

ruby-build: hbrew
	$(binstall)

rbenv-default-gems: hbrew
	$(binstall)

ruby: rbenv ruby-build rbenv-default-gems
	@echo 'bundler' >> "$$(brew --prefix rbenv)/default-gems"

nvm: hbrew
	$(binstall)

node: nvm
	@mkdir /usr/local/var/nvm
	@cp $$(brew --prefix nvm)/nvm-exec /usr/local/var/nvm/
