#!/usr/bin/env bash

# download siji and install 
install_siji_font() {
	git clone https://github.com/stark/siji /opt/siji/
	pushd /opt/siji/
	./install.sh
}

# enable bitmap fonts (for siji in polybar)
enable_bitmaps_fonts(){
	ln -s /etc/fonts/conf.avail/70-force-bitmaps.conf /etc/fonts/conf.d/
	unlink /etc/fonts/conf.d/70-no-bitmaps.conf
	dpkg-reconfigure fontconfig
}

install_siji_font
enable_bitmap_fonts
