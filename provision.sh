#!/usr/bin/env bash

echo "Setting up the hosts file"
echo "192.168.33.11 node1" >> /etc/hosts
echo "192.168.33.12 node2" >> /etc/hosts
echo "192.168.33.13 node3" >> /etc/hosts

sudo yum -y install java-1.8.0-openjdk-devel

echo "installin mesos, marathon and docker"
echo "-------------------------------------"

rpm -Uvh http://repos.mesosphere.com/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm
yum -y install mesos marathon docker

echo "IP=192.168.33.11" >> /etc/default/mesos
sudo rm -f /etc/mesos/ip
sudo rm -f /etc/mesos-master/hostname
echo "192.168.33.11" >> /etc/mesos/ip
echo "192.168.33.11" >> /etc/mesos-master/hostname
#echo "192.168.33.10" >> /etc/mesos-slave/ip
#echo "192.168.33.10" >> /etc/mesos-slave/hostname
echo 'docker,mesos' > /etc/mesos-slave/containerizers
echo 'cgroups/devices,disk/du,docker/runtime,filesystem/linux' > /etc/mesos-slave/isolation
echo 'docker' > /etc/mesos-slave/image_providers
echo '10mins' > /etc/executor_registration_timeout

sudo cat <<EOT > /etc/docker/daemon.json
{
  "storage-driver": "devicemapper"
}
EOT

sudo echo "export LIBPROCESS_IP=192.168.33.11" >> /home/vagrant/.bashrc
sudo echo "export SPARK_LOCAL_IP=192.168.33.11" >> /home/vagrant/.bashrc

#disabling selinux
sudo sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config

source ~/.bashrc
#setting the --no-switch_user flag for mesos slave
sudo chmod 777 -R /etc/mesos-slave/
touch /etc/mesos-slave/?no-switch_user

echo "installing zookeeper"
echo "--------------------"

rpm -Uvh http://archive.cloudera.com/cdh4/one-click-install/redhat/6/x86_64/cloudera-cdh-4-0.x86_64.rpm
yum -y install zookeeper zookeeper-server

sudo -u zookeeper zookeeper-server-initialize --myid=1
service zookeeper-server start

echo "Starting mesos and docker"
echo "--------------------------"

sudo service docker start
sudo service mesos-master start
sudo service mesos-slave start
