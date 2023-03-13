#!/bin/bash
sudo yum -y update
sudo yum -y install httpd

# Format disks
sudo mkfs.xfs /dev/sdb
sudo mkfs.xfs /dev/sdc

# Create and mount directories
sudo mkdir /mnt/disk1
sudo mkdir /mnt/disk2
sudo mount /dev/sdb /mnt/disk1
sudo mount /dev/sdc /mnt/disk2

myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
listdisks=`df -h`
listdisks2=`lsblk -af`

cat <<EOF > /var/www/html/index.html
<html>
<body bgcolor="black">
<h2><font color="gold">Terraform <font color="red"> v1.3.7</font></h2><br><p>
<font color="green">Server PrivateIP: <font color="aqua">$myip<br><br>
<font color="magenta">
<b>Version 3.0</b>
</body>
</html>
EOF

echo "<pre>$listdisks</pre>" >> /var/www/html/index.html
echo "<pre>$listdisks2</pre>" >> /var/www/html/index.html

sudo systemctl start httpd.service
sudo systemctl enable httpd.service