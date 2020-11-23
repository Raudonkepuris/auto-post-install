#!/bin/sh

#Install yay and other things
git clone https://aur.archlinux.org/yay.git /tmp/yay
chmod 777 /tmp/yay
cd /tmp/yay
makepkg -si
yay -S nerd-fonts-mononoki pfetch-git

#Install completely tos complient spotify build (sarcasm)
read -r -p "Install completely tos complient ad blocked spotify? [y/n] " response
response=${response,,}
if [[ "$response" =~ ^(yes|y)$ ]]
then
	yay -S spotify
	curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | gpg --import -
	git clone https://github.com/abba32/spotify-adblock-linux.git /tmp/spotify-adblock
	wget -P /etc/spotify-adblock -0 cef.tar.bz2 "http://opensource.spotify.com/cefbuilds/cef_binary_80.0.8%2Bgf96cd1d%2Bchromium-80.0.3987.132_linux64_minimal.tar.bz2"
	cd /tmp/spotify-adblock
	tar -xf cef.tar.bz2 --wildcards '*/include' --strip-components=1
	
	sudo make install
fi
