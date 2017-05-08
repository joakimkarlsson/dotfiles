#!/usr/bin/env bash

# Needed for 'add-apt-repository'
sudo apt install software-properties-common -y

# Needed for libxcb-xrm-dev, needed by i3wm
sudo add-apt-repository ppa:aguignard/ppa -y

# Needed for Vim8 with good compile flags
sudo add-apt-repository ppa:pi-rho/dev -y

# Update packges list
sudo apt update

# Install Xfce4
sudo apt install xubuntu-desktop gnome-terminal menu --no-install-recommends -y
sudo apt install gnome-terminal xfwm4-themes xfce4-terminal --no-install-recommends -y

sudo apt install build-essential curl -y

mkdir -p ~/.builds

# Dependencies for i3-gaps
sudo apt install libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf libxcb-xrm-dev libxcb-xrm-dev -y

# Get i3-gaps
if [[ ! -d ~/.builds/i3-gaps ]]; then
    git clone https://www.github.com/Airblader/i3 ~/.builds/i3-gaps
else
    pushd ~/.builds/i3-gaps
    git pull
    popd
fi

pushd ~/.builds/i3-gaps
autoreconf --force --install
rm -rf build/
mkdir -p build && cd build/

../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
make
sudo make install

popd

# polybar
sudo apt install cmake cmake-data libcairo2-dev libxcb1-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev libxcb-util0-dev libxcb-xkb-dev pkg-config python-xcbgen xcb-proto libxcb-xrm-dev libasound2-dev libmpdclient-dev libiw-dev libcurl4-openssl-dev -y

if [[ ! -d ~/.builds/polybar ]]; then
    git clone --branch 3.0.5 --recursive https://github.com/jaagr/polybar ~/.builds/polybar
else
    pushd ~/.builds/polybar
    git pull
    popd
fi

# if [[ -d ~/polybar/build ]]; then
#     rm -rf ~/polybar/build
# fi

mkdir -p ~/.builds/polybar/build
pushd ~/.builds/polybar/build
cmake ..
sudo make install
popd

# Arc Theme
sudo apt install libgtk-3-dev gnome-themes-standard gtk2-engines-murrine -y

if [[ ! -d ~/.builds/arc-theme ]]; then
    git clone https://github.com/horst3180/arc-theme --depth 1 ~/.builds/arc-theme
else
    pushd ~/.builds/arc-theme
    git pull
    popd
fi

pushd ~/.builds/arc-theme
./autogen.sh --prefix=/usr
sudo make install
popd

# Download fonts
mkdir -p ~/.local/share/fonts

pushd ~/.local/share/fonts
curl -fLo "DejaVu Sans Mono Nerd Font Complete Mono.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete%20Mono.ttf?raw=true
popd

# Tmux 2.4
sudo apt install libevent-dev libncurses-dev -y

if [[ ! -d ~/.builds/tmux ]]; then
    git clone --branch 2.4 https://github.com/tmux/tmux.git ~/.builds/tmux
else
    pushd ~/.builds/tmux
    git pull
    popd
fi

pushd ~/.builds/tmux
sh autogen.sh
./configure && make
sudo make install
popd


sudo apt install zsh vim silversearcher-ag -y

# Python
sudo apt install python3-venv python3-dev -y

sudo apt install firefox -y

# Link dotfiles needed

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 

ln -s $DIR/.config/base16-shell $HOME/.config
ln -s $DIR/.vim $HOME
ln -s $DIR/.zshfunctions $HOME
ln -s $DIR/.ctags $HOME
ln -s $DIR/.tmux.conf $HOME
ln -s $DIR/.tmuxline.conf $HOME
ln -s $DIR/.vimrc $HOME
ln -s $DIR/.zshrc $HOME
ln -s $DIR/.config/autostart $HOME/.config
ln -s $DIR/.config/i3 $HOME/i3
ln -s $DIR/.config/polybar $HOME/polybar

mkdir -p $HOME/.config/xfce4/xfconf/xfce-perchannel-xml
ln -s $DIR/.config/xfce4/xfconf/xfce-perchannel-xml/* $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/

# Clear any saved Xfce sessions
rm -rf ~/.cache/sessions
