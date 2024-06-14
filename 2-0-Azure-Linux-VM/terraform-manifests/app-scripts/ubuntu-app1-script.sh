#!/bin/sh
sudo apt update -y
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
sudo apt-get install tailscale
sudo tailscale up --authkey ${tailscale_tailnet_key.web_vm_key.key}
sudo apt install -y apache2
sudo systemctl enable apache2
sudo systemctl start apache2
sudo ufw disable
sudo chmod -R 777 /var/www/html
echo "Welcome to Culak Azure Web - WebVM App1 - VM Hostname: $(hostname)" | sudo tee /var/www/html/index.html
sudo mkdir /var/www/html/app1
echo "Welcome to Culak Azure Web - WebVM App1 - VM Hostname: $(hostname)" | sudo tee /var/www/html/app1/hostname.html
echo "Welcome to Culak Azure Web - WebVM App1 - App Status Page" | sudo tee /var/www/html/app1/status.html
echo '<!DOCTYPE html> <html> <body style="background-color:rgb(250, 210, 210);"> <h1>Welcome to Stack Simplify - WebVM APP-1 </h1> <p>Terraform Demo</p> <p>Application Version: V1</p> </body></html>' | sudo tee /var/www/html/app1/index.html
sudo curl -H "Metadata:true" --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2020-09-01" -o /var/www/html/app1/metadata.html