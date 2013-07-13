#!/bin/bash
# Simple setup.sh for configuring Ubuntu 12.04 LTS EC2 instance
# for headless setup. 

function lnDot {
	[[ -e "${1}" ]] || return
	if [[ -L "${1}" ]]; then
		ln -sf "dotfiles/${1}" $2
	elif [[ -f "${1}" ]]; then
		ln -sb "dotfiles/${1}" $2
	elif [[ -d "${1}/" ]]; then
		mv "${1}" "${1}~"
		ln -sf "dotfiles/${1}" $2
	fi
}
# Install realpath that is used in most of our scripts
sudo apt-get install -y realpath
# Install nvm: node-version manager
# https://github.com/creationix/nvm
sudo apt-get install -y git-core
curl https://raw.github.com/creationix/nvm/master/install.sh | sh


# Load nvm and install latest production node
source $HOME/.nvm/nvm.sh
nvm install v0.10.12
nvm use v0.10.12

# Install jshint to allow checking of JS code within emacs
# http://jshint.com/
npm install -g jshint

# Install rlwrap to provide libreadline features with node
# See: http://nodejs.org/api/repl.html#repl_repl
sudo apt-get install -y rlwrap

# Install emacs24
# https://launchpad.net/~cassou/+archive/emacs
sudo apt-add-repository -y ppa:cassou/emacs
sudo apt-get update
sudo apt-get install -y emacs24 emacs24-el emacs24-common-non-dfsg

git pull and install dotfiles as well
cd $HOME
if [ -d ./dotfiles/ ]; then
    mv dotfiles dotfiles.old
fi
git clone https://github.com/marcobox/dotfiles.git
lnDot .screenrc .
lnDot .bash_profile .
lnDot .bashrc .
lnDot .bashrc_custom .
lnDot .tmux.conf
lnDot .tmux.conf.debug
lnDot .vimrc .
lnDot .tmux .
lnDot .emacs.d .
lnDot .ssh .
lnDot .terminfo .
lnDot bin .

sudo cp -b setup/noip /etc/init.d/
sudo chown root:root /etc/init.d/noip
