#!/bin/bash

# Summary: Install base packages for Ruby development

gem update --system
gem install bundler github-pages
gem cleanup
