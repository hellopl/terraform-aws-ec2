#!/bin/bash
yum -y update
yum -y install httpd


myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
listdisks=`fdisk -l | base64`

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

sudo systemctl start httpd.service
sudo systemctl enable httpd.service