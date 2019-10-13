#!/bin/zsh

# Summary: Install base packages for Python development

#  Environment tools
pip3 install pipdeptree graphviz pipenv ipython

# Linting tools
pip3 install flake8 flake8_docstrings pep8-naming pylint vulture black pyls
