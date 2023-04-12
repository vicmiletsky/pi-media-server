# zram
echo ""
echo "Install zram"
echo ""
git clone https://github.com/StuartIanNaylor/zram-swap-config
cd zram-swap-config
chmod +x install.sh && sudo ./install.sh
cd ..
rm -rf zram-swap-config
cat zram/config.conf | sudo tee /etc/zram-swap-config.conf

# docker
echo ""
echo "Install docker"
echo ""
sudo apt-get update
sudo apt install docker.io -y
sudo systemctl start docker
sudo curl -L "https://github.com/docker/compose/releases/download/v2.17.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo docker -v
sudo docker-compose -v

# ssd setup
echo ""
echo "Setup portable SSD"
echo ""
sudo mkdir /mnt/Samsung_T5
sudo mount /dev/sda1 /mnt/Samsung_T5 -o uid=1000,gid=1000,umask=000
ls -l /mnt/Samsung_T5
sudo mkdir -p /mnt/Samsung_T5/torrents
sudo chown -R victor:victor /mnt/Samsung_T5/torrents

# startup script
echo ""
echo "Setup startup script"
echo ""
sudo sed -i 's/exit 0/ /' /etc/rc.local
echo "sudo mount /dev/sda1 /mnt/Samsung_T5 -o uid=1000,gid=1000,umask=000" | sudo tee -a /etc/rc.local
echo "ls -l /mnt/Samsung_T5" | sudo tee -a /etc/rc.local
echo "cd /home/victor/pi-media-server && sudo docker-compose up -d" | sudo tee -a /etc/rc.local
echo "exit 0" | sudo tee -a /etc/rc.local

# start services
read -p "Press any key to start services"
sudo docker-compose up -d
