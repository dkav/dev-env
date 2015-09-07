# Summary: Install Jekyll
#
# Usage: rb_jekyll <Ruby version>
#

ruby_version=$1

if [ -z "$ruby_version" ]; then
     echo "Usage: rb_jekyll <Ruby version>"
else
    . ~/.bash_profile
    rbdev
    rbenv shell $ruby_version
    rbenv-gemset create $ruby_version jekyll
    RBENV_GEMSETS="jekyll" gem install jekyll
fi
