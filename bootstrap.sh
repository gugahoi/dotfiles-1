#!/usr/bin/env bash

set -e
set -o pipefail

base() {
	apt update
	apt -y upgrade
	apt install \
		alsa-utils \
		cmatrix \
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
		tlp \
		tlp-rdw \
		wicd \
		wicd-curses

	apt autoremove
	apt autoclean
	apt clean

	install_docker
}

# installs docker master
install_docker() {
	groupadd docker
	gpasswd -a $USER docker

	apt-get install \
	    apt-transport-https \
	    ca-certificates \
	    curl \
	    software-properties-common	

	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

	# zesty because artful (17.10) is no good for now
	add-apt-repository \
	   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	   zesty \
	   stable"

	apt update
	apt install -y docker-ce
	
	apt autoremove
	apt autoclean
	apt clean
}

# install go from gophers repo
install_golang() {
	export GO_VERSION
	GO_VERSION=$(curl -sSL "https://golang.org/VERSION?m=text")
	export GO_SRC=/usr/local/go

	# if we are passing the version
	if [[ ! -z "$1" ]]; then
		GO_VERSION=$1
	fi

	# purge old src
	if [[ -d "$GO_SRC" ]]; then
		sudo rm -rf "$GO_SRC"
		sudo rm -rf "$GOPATH"
	fi

	GO_VERSION=${GO_VERSION#go}

	# subshell
	(
		curl -sSL "https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz" | sudo tar -v -C /usr/local -xz
		local user="$USER"
		# rebuild stdlib for faster builds
		sudo chown -R "${user}" /usr/local/go/pkg
		CGO_ENABLED=0 $GO_SRC/bin/go install -a -installsuffix cgo std
		ln -s $GO_SRC/bin/go /usr/local/bin/go
	)
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

check_is_sudo() {
	if [ "$EUID" -ne 0 ]; then
		echo "Please run as root."
		exit
	fi
}

usage() {
	echo -e "install.sh\\n\\tThis script installs my basic setup for a Ubuntu Minimal 17.10 laptop\\n"
	echo "Usage:"
	echo "  golang                              - install golang and packages"
}


main() {
	# must run this with sudo to do the thing with the thing
	check_is_sudo
	local cmd=$1

	if [[ -z "$cmd" ]]; then
		usage
		exit 1
	fi

	#base
	#install_docker
	install_golang
	#install_spotify
	#symlinks
}

main "$@"
