#!/usr/bin/env bash

echo "Setting up the hosts file"
echo "192.168.33.11 node1" >> /etc/hosts
echo "192.168.33.12 node2" >> /etc/hosts
echo "192.168.33.13 node3" >> /etc/hosts

sudo yum -y install java-1.8.0-openjdk-devel

echo "installin mesos and marathon"
echo "----------------------------"

rpm -Uvh http://repos.mesosphere.com/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm
yum -y install mesos marathon

echo "IP=192.168.33.11" >> /etc/default/mesos
sudo rm -f /etc/mesos/ip
sudo rm -f /etc/mesos-master/hostname
echo "192.168.33.11" >> /etc/mesos/ip
echo "192.168.33.11" >> /etc/mesos-master/hostname
#echo "192.168.33.10" >> /etc/mesos-slave/ip
#echo "192.168.33.10" >> /etc/mesos-slave/hostname

sudo echo "export LIBPROCESS_IP=192.168.33.11" >> /home/vagrant/.bashrc
sudo echo "export SPARK_LOCAL_IP=192.168.33.11" >> /home/vagrant/.bashrc

sourc ~/.bashrc
#setting the --no-switch_user flag for mesos slave
sudo chmod 777 -R /etc/mesos-slave/
touch /etc/mesos-slave/?no-switch_user

echo "installing zookeeper"
echo "--------------------"

rpm -Uvh http://archive.cloudera.com/cdh4/one-click-install/redhat/6/x86_64/cloudera-cdh-4-0.x86_64.rpm
yum -y install zookeeper zookeeper-server

sudo -u zookeeper zookeeper-server-initialize --myid=1
service zookeeper-server start

echo "Starting mesos"
echo "--------------"

sudo service mesos-master start
sudo service mesos-slave start
