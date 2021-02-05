#!/bin/sh

programs_list="git w3m vim firefox qbittorrent zathura zathura-pdf-mupdf zsh sxiv exa fontconfig gimp htop mpv vlc pcmanfm ranger rsync openssh xf86-video-intel alsa alsa-utils pulseaudio pulseaudio-alsa pamixer pulsemixer xorg xorg-server xorg-xinit devour discord exa ffmpeg firefox gcc gimp inxi maim mpv pamixer qbittorrent ranger rsync syncthing spacefm sxiv droidcam vlc w3m weechat xclip youtube-dl zathura zoom"


#Add user
while true; do
	read -r -p "Setup a user [y/n] " response
	response=${response,,}
	if [[ "$response" =~ ^(yes|y)$ ]]
	then
		read -r -p "What should be the name of the user: " username
		read -r -p "Should the user be a part of the wheel group [y/n] " wheel
		wheel=${wheel,,}
		if [[ "$wheel" =~ ^(yes|y)$ ]]
		then
			echo "Adding user to wheel group"
			useradd -mG wheel $username
		else
			echo "Creating user (no wheel group"
			useradd -m $username
		fi
	echo "Create password for user " $username
	passwd $username
	else
		break	
	fi
done


#Allowing wheel group to use sudo
sed -i -e "s/#wheel ALL=(ALL) ALL/wheel ALL=(ALL) ALL" /etc/sudoers


#Installing programs
pacman -Syu
echo "Following programs will be installed: " $programs_list
read -r -p "Continue (n for modifying) [y/n] " response
response=${response,,}
if [[ "$response" =~ ^(yes|y)$ ]]
then	
	pacman -S $programs_list
else
	echo "Current programs list: " $programs_list
	read -r -p "Programs to remove (write them out with spaces separating them) " programs_to_remove
	for program in $programs_to_remove; do
		programs_list="$(echo "$programs_list" | sed "s/$program //")"
	done
	echo "Modified program list: " $programs_list
	read -r -p "Programs to add (write them ou with spaces separating them) " programs_to_add
	programs_list=$programs_list" "$programs_to_add
	echo "Following programs will be installed: " $programs_list
	pacman -S $programs_list
fi


#Installing dwm
## Note to self: when I begin using XDM fix to work with XDM
echo "Installing my suckless utility builds"
git clone https://www.github.com/Raudonkepuris/dwm /usr/local/src/dwm
git clone https://www.github.com/Raudonkepuris/st /usr/local/src/st 
git clone https://www.github.com/Raudonkepuris/dwmblocks /usr/local/src/dwmblocks 
git clone https://www.github.com/Raudonkepuris/dmenu /usr/local/src/dmenu 

make -C /usr/local/src/dwm clean install
make -C /usr/local/src/st clean install
make -C /usr/local/src/dwmblocks clean install
make -C /usr/local/src/dmenu clean install


#Setting up dotfiles shell etc
## Note to self: when I begin using XDM fix to work with XDM
echo "Setting up my dotfiles"
users=$(ls /home)
git clone https://www.github.com/Raudonkepuris/dotfiles /tmp/dotfiles
for user in $users; do
	cp -rv /tmp/dotfiles/.* /home/$user/
	chown $user /home/$user/*
	chown $user /home/$user/.*
	chsh -s /bin/zsh
done
