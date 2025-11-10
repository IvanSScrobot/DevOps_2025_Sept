#!/bin/bash
sudo dnf update
sudo dnf install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
echo "Hello, World from $(hostname -f)" | sudo tee /usr/share/nginx/html/index.html