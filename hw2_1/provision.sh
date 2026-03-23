apt update
apt -y upgrade
apt install -y openssh-server  
    systemctl enable ssh
    systemctl start ssh
apt update

