#!/bin/sh
echo "Installing Docker"
apt-get install -y docker.io docker-compose
curl -ks https://packagecloud.io/install/repositories/Hypriot/Schatzkiste/script.deb.sh | sudo bash
apt-get install -y docker-hypriot=1.10.3-1
sh -c 'usermod -aG docker $SUDO_USER'
systemctl enable docker.service
systemctl unmask docker.service
systemctl unmask docker.socket
systemctl start docker.service

echo "Installing & Configuring Network Components"
apt-get update
apt-get upgrade
apt-get install -y ifupdown raspberrypi-net-mods man
apt-get install -y hostapd dnsmasq dhcpcd5

/bin/cp configs/dhcpcd /etc/dhcpcd.conf
service dhcpcd restart

/bin/cp configs/interfaces /etc/network/interfaces
ifdown wlan0
ifup wlan0

/bin/cp configs/dnsmasq /etc/dnsmasq.d/wlan0
/bin/cp configs/hostapd /etc/default/hostapd

service hostapd restart
service dnsmasq restart
