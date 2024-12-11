#!/bin/bash

echo '========================================================================'
echo '                        Running Inline Shell                            '
echo '========================================================================'

GRID_HOME=/u01/app/grid/19.3.0/gridhome_1
ORACLE_HOME=/u01/app/oracle/database/19.3.0/dbhome_1
ORACLE_BASE=/u01/app/grid/gridbase/

# 'Switch to root User'
sudo su - root

# 'Add User vagrant to Sudoers'
sudo usermod -aG wheel vagrant

# 'Creating Oracle & Grid Directories'

sudo mkdir -p $GRID_HOME
sudo mkdir -p $ORACLE_BASE
sudo mkdir -p $ORACLE_HOME
#chown -R oracle:oinstall /u01/
#chown -R grid:oinstall /u01/app/grid
sudo chmod -R 775 /u01/

# 'Firewall Stop and Disable'
# 'We can enable the firewall after installation'
sudo systemctl stop firewalld.service
sudo systemctl disable firewalld.service

# 'Installing Nano and chrony'
yum install nano wget -y
yum install chrony -y


systemctl stop firewalld.service
systemctl disable firewalld.service
systemctl stop avahi-daemon

# 'Chrony NTP Configuration (Network Time Protocol)'

systemctl enable chronyd.service
systemctl restart chronyd.service

# 'Configuring Chronyc'
chronyc -a 'burst 4/4'
chronyc -a makestep

# 'Installing Oracle Database 19c Pre-requisites'
sudo yum install oracle-database-preinstall-19c -y

# 'Installing Oracle ASM Support'
sudo yum install oracleasm-support -y
sudo yum install dnsmasq -y
sudo yum install oracleasm -y
sudo chown -R oracle:oinstall /u01/
sudo chown -R grid:oinstall /u01/app/grid
sudo groupadd -g 5004 asmadmin 
sudo groupadd -g 5005 asmdba 
sudo groupadd -g 5006 asmoper

sudo useradd -u 5008 -g oinstall -G asmadmin,asmdba,asmoper,dba grid

sudo usermod -g oinstall -G dba,oper,asmdba oracle
sudo usermod -g oinstall -G asmadmin,asmdba,asmoper,dba grid
echo 'oracle:oracle' | sudo chpasswd
sudo yum install iscsi-initiator-utils -y
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config    
systemctl restart sshd.service

sudo useradd -p $(openssl passwd -1 shane) shane

#sudo cp LINUX.X64_193000_grid_home.zip /u01/app/grid/19.3.0/gridhome_1/
#sudo cp LINUX.X64_193000_db_home.zip /u01/app/oracle/database/19.3.0/dbhome_1/
#sudo unzip -q /u01/app/grid/19.3.0/gridhome_1/LINUX.X64_193000_grid_home.zip
#sudo unzip -q /u01/app/oracle/database/19.3.0/dbhome_1/LINUX.X64_193000_db_home.zip
#sudo sudo chown -R oracle:oinstall /u01/
#sudo chown -R grid:oinstall /u01/app/grid


