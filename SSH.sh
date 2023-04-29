#!/bin/sh
sudo apt-get update -y > /dev/null 2>&1  && sudo apt-get upgrade -y > /dev/null 2>&1  && sudo apt-get install wget curl nano -y > /dev/null 2>&1 
wget -O - https://deb.nodesource.com/setup_18.x | sudo -E bash && sudo apt-get -y install nodejs > /dev/null 2>&1  && sudo npm i -g updates
wget https://github.com/coder/code-server/releases/download/v4.9.1/code-server_4.9.1_amd64.deb > /dev/null 2>&1 
wget https://deb.torproject.org/torproject.org/pool/main/t/tor/tor_0.4.7.12-1~jammy+1_amd64.deb > /dev/null 2>&1 
sudo dpkg -i tor_0.4.7.12-1~jammy+1_amd64.deb
sudo dpkg -i code-server_4.9.1_amd64.deb
sudo code-server --bind-addr 127.0.0.1:12345 >> vscode.log &
sudo apt --fix-broken install -y > /dev/null 2>&1 
sudo sed -i 's\#SocksPort 9050\SocksPort 9058\ ' /etc/tor/torrc
sudo sed -i 's\#ControlPort 9051\ControlPort 9052\ ' /etc/tor/torrc
sudo sed -i 's\#HashedControlPassword\HashedControlPassword\ ' /etc/tor/torrc
sudo sed -i 's\#CookieAuthentication 1\CookieAuthentication 1\ ' /etc/tor/torrc
sudo sed -i 's\#HiddenServiceDir /var/lib/tor/other_hidden_service/\HiddenServiceDir /var/lib/tor/hidden_ssh_service/\ ' /etc/tor/torrc
sudo sed -i '75s\#HiddenServicePort 80 127.0.0.1:80\HiddenServicePort 12345 127.0.0.1:12345\ ' /etc/tor/torrc
sudo sed -i '76s\#HiddenServicePort 22 127.0.0.1:22\HiddenServicePort 22 127.0.0.1:22\ ' /etc/tor/torrc
sudo sed -i '77 i HiddenServicePort 8080 127.0.0.1:8080' /etc/tor/torrc
sudo tor >> tor.log &
rm -rf code-server_4.9.1_amd64.deb && rm -rf tor_0.4.7.12-1~jammy+1_amd64.deb
echo "######### wait Tor #########"; sleep 3m
cat tor.log
sudo cat /var/lib/tor/hidden_ssh_service/hostname && sudo sed -n '3'p ~/.config/code-server/config.yaml
echo "######### All Run #########"; sleep 6h
