#!/usr/bin/env bash

set -e
set -o pipefail

base() {
	apt update
	apt -y upgrade
	apt install \
		alsa-utils \
		compton \
		curl \
		git \
		i3 \
		jq \
		neovim \
		network-manager \
		openvpn \
		rofi \
		s3cmd \
		terminator \
		tlp tlp-rdw \
		wicd \
		wicd-curses

	apt autoremove
	apt autoclean
	apt clean

	install_docker
}

# installs docker master
install_docker() {
	apt-get install \
	    apt-transport-https \
	    ca-certificates \
	    curl \
	    software-properties-common	

	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

	add-apt-repository \
	   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	   $(lsb_release -cs) \
	   stable"

	apt update
	apt install docker-ce
	
	apt autoremove
	apt autoclean
	apt clean
}

# install go from gophers repo
install_go() {
	add-apt-repository ppa:gophers/archive
	apt update
	apt install golang-1.9-go
}	

install_spotify() {
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0DF731E45CE24F27EEEB1450EFDC8610341D9410
	echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
	apt update
	apt install spotify-client
}


# symlink all the things
symlinks() {
	ln -s ~/.dotfiles/.wallpaper ~/.wallpaper
}

install_spotify
