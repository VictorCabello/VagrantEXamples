#! /bin/bash


# Install repository that contains the salt products
yes | sudo rpm -Uvh http://ftp.linux.ncsu.edu/pub/epel/6/i386/epel-release-6-8.noarch.rpm

# Install the most resent minion
sudo yum --enablerepo=epel-testing -y install salt-minion

# Run salt's demon when the machine restart
sudo chkconfig salt-minion on

# Add the master ip on the host file to be reached 
echo "192.168.123.138 salt" >> /etc/hosts

# Run the salt demon now
sudo service salt-minion start

# Suggestion
echo "The minion is ready now is necesary run the command salt-key -A on the master"
