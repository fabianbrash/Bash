##Set a hostname for the system, this is argument 3
hostnamectl set-hostname $1 --static
systemctl restart systemd-hostnamed
