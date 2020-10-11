﻿#!/bin/bash
#
# Autheur:
#   Amaury Libert <amaury-libert@hotmail.com> de Blabla Linux <https://blablalinux.be>
#
# Description:
#   Script d'installations logiciels pour Linux Mint 20 (Cinnamon/Mate/xfce) afin d'obtenir la suite logiciels SRV "Stream Record Virtualisation".
#
# Préambule Légal:
# 	Ce script est un logiciel libre.
# 	Vous pouvez le redistribuer et / ou le modifier selon les termes de la licence publique générale GNU telle que publiée par la Free Software Foundation; version 3.
#
# 	Ce script est distribué dans l'espoir qu'il sera utile, mais SANS AUCUNE GARANTIE; sans même la garantie implicite de QUALITÉ MARCHANDE ou d'ADÉQUATION À UN USAGE PARTICULIER.
# 	Voir la licence publique générale GNU pour plus de détails.
#
# 	Licence publique générale GNU : <https://www.gnu.org/licenses/gpl-3.0.txt>
#
# Effacement ecran
echo "Effacement écran..."
clear
#
#
# Rafraîchissement dépôts
echo "Rafraîchissement dépôts + mises à jour..."
apt update && apt upgrade -y
#
#
# Logiciels hors dépôts (installations)
echo "Ajouts du dépôt supplémentaire : obsproject pour obs-studio..."
add-apt-repository ppa:obsproject/obs-studio -y
#
echo " Ajout de la clé d'authentification et du dépôt supplémentaire virtualbox..." 
wget -q -O- http://download.virtualbox.org/virtualbox/debian/oracle_vbox_2016.asc | apt-key add -
echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian eoan contrib" | tee /etc/apt/sources.list.d/virtualbox.list
#
echo "Téléchargement de VMware-Player-16.0.0-16894299.x86_64.bundle + rendre éxécutable..."
wget ftp://services.anyathome.be/linux/soft/bundle/vmware/player-workstation/VMware-Player-16.0.0-16894299.x86_64.bundle
chmod +x VMware-Player-16.0.0-16894299.x86_64.bundle
#
echo "Rafraîchissement dépôts..."
apt update
#
echo "Installations de ffmpeg, obs-studio, virtualbox..."
apt install -y ffmpeg obs-studio virtualbox-6.1
#
echo "Téléchargement du pack d'extension USB..."
version=$(VBoxManage --version|cut -dr -f1|cut -d'_' -f1) && wget -c http://download.virtualbox.org/virtualbox/$version/Oracle_VM_VirtualBox_Extension_Pack-$version.vbox-extpack
#
echo "Installation du pack d'extension USB..."
echo "y" | VBoxManage extpack install --replace Oracle_VM_VirtualBox_Extension_Pack-$version.vbox-extpack
#
echo "VirtualBox ajouts groupes..."
usermod -G vboxusers -a $SUDO_USER
usermod -G disk -a $SUDO_USER
#
echo "Installation de VMware-Player-16.0.0-16894299.x86_64.bundle..."
./VMware-Player-16.0.0-16894299.x86_64.bundle
#
#
# Logiciels à partir des dépôts (installations)
echo "Installations de logiciels (et thème) à partir des dépôts : papirus-icon-theme, arc-theme, htop, nmon, neofetch, audacity, kdenlive, clipit, simplescreenrecorder, qemu, qemu-kvm, libvirt0, virt-manager, libguestfs-tools, ssh-askpass, bridge-utils, gnome-boxes..."
apt install -y papirus-icon-theme arc-theme htop nmon neofetch audacity kdenlive clipit simplescreenrecorder
apt install -y -o 'apt::install-recommends=true' \
  qemu qemu-kvm libvirt0 virt-manager libguestfs-tools ssh-askpass bridge-utils gnome-boxes
#  
echo "KVM ajouts groupes..."
usermod -G kvm -a $SUDO_USER
usermod -G libvirt -a $SUDO_USER
#
#
# Suppression + Nettoyage
echo "Suppression de VMware-Player-16.0.0-16894299.x86_64.bundle et du pack d'extension USB VirtualBox..."
rm *.bundle *.vbox-extpack
#
echo "Nettoyage..."
apt autoremove
