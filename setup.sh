#!/bin/bash
# Simple setup.sh for configuring Ubuntu 12.04 LTS EC2 instance
# for headless setup. 

function lnDot {
	[[ -n "${1}" ]] || return
	if [[ -L "${1}" ]]; then
		ln -sf "dotfiles/${1}" $2
	elif [[ -f "${1}" ]]; then
		ln -sb "dotfiles/${1}" $2
	elif [[ -d "${1}/" ]]; then
		mv "${1}" "${1}~"
		ln -sf "dotfiles/${1}" $2
	else
		ln -s "dotfiles/${1}" $2
	fi
}
# Install realpath that is used in most of our scripts
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y realpath
sudp apt-get install -y exuberant-ctags
# Build essential compiling tools
sudo apt-get install -y build-essential checkinstall
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
wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
# Install noip2 tool without configuration file
cd $HOME
git clone https://github.com/marcobox/setup
git --git-dir="setup/.git" remote rm origin
git --git-dir="setup/.git" remote add origin git@github.com:marcobox/setup.git
git --git-dir="setup/.git" remote add upstream https://github.com/startup-class/setup.git

cd setup
sudo tar --no-same-owner -xzf noip2.tar.gz -C /tmp/
cd /tmp/noip2
sudo make install
sudo update-rc.d noip defaults

# git pull and install dotfiles as well
cd $HOME
if [ -d ./dotfiles/ ]; then
    mv dotfiles dotfiles.old
fi
git --recursive clone https://github.com/marcobox/dotfiles.git
git --git-dir="dotfiles/.git" remote rm origin
git --git-dir="dotfiles/.git" remote add origin git@github.com:marcobox/dotfiles.git
git --git-dir="dotfiles/.git" remote add upstream https://github.com/startup-class/dotfiles.git
lnDot .screenrc
lnDot .bash_profile
lnDot .bashrc
lnDot .bashrc_custom
lnDot .tmux.conf
lnDot .tmux.conf.debug
lnDot .vimrc
lnDot .vim
lnDot .tmux
lnDot .emacs.d
lnDot .ssh
lnDot .terminfo
lnDot .gitconfig
lnDot .jshintrc
lnDot bin

