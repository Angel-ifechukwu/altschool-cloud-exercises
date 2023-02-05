#!/bin/bash
apt update -y
apt install apache2 -y
systemctl enable apache2
systemctl restart apache2