#!/bin/bash

# usage: source rubyenv

PATH="$(ruby -e "puts Gem.user_dir")/bin:$PATH"
