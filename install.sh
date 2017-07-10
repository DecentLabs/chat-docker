#!/bin/sh
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

echo "Upgrading world..."
apt-get update
apt-get -y upgrade

echo "Installing Docker"
apt-get install -y docker.io docker-compose git
curl -ks https://packagecloud.io/install/repositories/Hypriot/Schatzkiste/script.deb.sh | sudo bash
apt-get install -y docker-hypriot=1.10.3-1
sh -c 'usermod -aG docker $SUDO_USER'
systemctl enable docker.service
systemctl unmask docker.service
systemctl unmask docker.socket
systemctl start docker.service

echo "Installing & Configuring Network Components"
apt-get purge -y dhcpcd5
apt-get install -y ifupdown raspberrypi-net-mods man
apt-get install -y hostapd dnsmasq

/bin/cp configs/resolvconf /etc/resolvconf.conf
/bin/cp configs/interfaces /etc/network/interfaces
ifdown wlan0
ifup wlan0

/bin/cp configs/dnsmasq /etc/dnsmasq.d/wlan0
/bin/cp configs/hostapd /etc/default/hostapd

service hostapd restart
service dnsmasq restart
