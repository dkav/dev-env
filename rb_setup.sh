# Summary: Setup Ruby virtual environment
#
# Usage: rb_setup <Ruby version>
#

ruby_version=$1

if [ -z "$ruby_version" ]; then
    echo "Usage: rb_setup <Ruby version>"
else
    # Setup Ruby virtual environment
    brew install rbenv rbenv-gemset ruby-build

    # Install Ruby
    . ~/.bash_profile
    rbdev
    rbenv install $ruby_version
    rbenv rehash
fi
