FROM resin/rpi-raspbian
RUN apt-get update
RUN apt-get upgrade
RUN apt-get install -y ifupdown raspberrypi-net-mods man
RUN apt-get install -y hostapd dnsmasq dhcpcd5

RUN echo "denyinterfaces wlan0" >> /etc/dhcpcd.conf
RUN service dhcpcd restart

COPY configs/interfaces /etc/network/interfaces
RUN ifdown wlan0
RUN ifup wlan0

COPY configs/dnsmasq /etc/dnsmasq.d/wlan0
COPY configs/hostapd /etc/default/hostapd

RUN service hostapd start
RUN service dnsmasq start

