PACKAGE_TO_INSTALL="mod_dav_svn subversion"
SVN_CONF_FILE="/etc/httpd/conf.d/subversion.conf"
sudo yum -y install $PACKAGE_TO_INSTALL

sudo touch  $SVN_CONF_FILE 
sudo cat >  $SVN_CONF_FILE <<EOF
LoadModule dav_svn_module     modules/mod_dav_svn.so
LoadModule authz_svn_module   modules/mod_authz_svn.so
 
<Location /svn>
   DAV svn
   SVNParentPath /var/www/svn
   AuthType Basic
   AuthName "Subversion repositories"
   AuthUserFile /etc/svn-auth-users
   Require valid-user
</Location>
EOF

htpasswd -b -c /etc/svn-auth-users admin test101

sudo mkdir /var/www/svn
cd /var/www/svn
sudo svnadmin create testrepo
sudo chown -R apache.apache testrepo

## If you have SELinux enabled (you can check it with "sestatus" command) ##
## then change SELinux security context with chcon command ##
 
chcon -h system_u:object_r:httpd_sys_content_t /var/www/svn/testrepo
 
## CentOS/RHEL 6.5/5.10 ##
# /etc/init.d/httpd restart
## OR ##
service httpd restart

mkdir -p /tmp/svn-structure-template/{trunk,branches,tags}


svn import -m 'Initial import' /tmp/svn-structure-template/ http://localhost/svn/testrepo --username admin --password test101 --no-auth-cache

cat > /etc/sysconfig/iptables <<EOF
# Firewall configuration written by system-config-firewall
# Manual customization of this file is not recommended.
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
EOF

sudo service iptables restart
echo "success"
