#!/bin/bash

cd ~
git clone https://github.com/trevorwhitney/dotfiles .dotfiles
.dotfiles/install.sh

mkdir workspace
cd workspace
git clone https://github.com/trevorwhitney/bosh-recipes
bosh-recipes/install_director.sh
