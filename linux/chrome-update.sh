
cd /tmp
rm google-chrome*.deb -f

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt-get -f install



