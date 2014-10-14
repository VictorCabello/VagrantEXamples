#! /bin/bash


# Install repository that contains the salt products
yes | sudo rpm -Uvh http://ftp.linux.ncsu.edu/pub/epel/6/i386/epel-release-6-8.noarch.rpm

# Install the most resent master
sudo yum --enablerepo=epel-testing -y install salt-master

# Run salt's demon when the machine restart
sudo chkconfig salt-master on

# Run the salt demon now
sudo service salt-master start

# Stop iptables
service iptables stop
