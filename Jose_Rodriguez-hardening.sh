#!/bin/bash

#Autor: Jose Alejandro Rodirguez Gutierrez

listado=$(yum list installed | grep '^clamav')
version=$(grep 'VERSION_ID' /etc/os-release)

#1. Script will identify the version of the operating system

echo '---PROCEEDING TO IDENTIFY THE VERSION OF OS---'
if [[ $version = 'VERSION_ID="8"' ]];
then
  echo '------YOUR OS IS CentOS v8--------------'

elif [[ $version = 'VERSION_ID="7"' ]];
then
  echo '------YOUR OS IS CentOS v7--------------'

fi

#2. Clamav antivirus will be installed or reinstalled if it is already installed 

yum list -q installed > lista

condicionclamav=$(grep '^clamav' lista)
echo $condicionclamav

if [[ $condicionclamav = "" ]];
then
  echo '------CLAMAV IS NOT INSTALLED-----------'
  yum -y install clamav
  echo '------SUCCESSFULLY INSTALLED------------'
else
  echo '------CLAMAV IS ALREADY INSTALLED, PROCEEDING TO UNINSTALL------'
  yum -y erase clamav*
  echo '------PROCEEDING TO INSTALL-------------'
  yum -y install clamav
  echo '------SUCCESSFULLY INSTALLED------------'
fi

#3. EPEL will be installed on Centos v7 servers 

if [[ $version = 'VERSION_ID="8"' ]];
then
  echo '------EPEL WILL NOT BE INSTALLED DUE TO THE CENTOS VERSION------'
elif [[ $version = 'VERSION_ID="7"' ]];
then
  echo '------CENTOS v7 DETECTED, EPEL WILL BE INSTALLED------'
  yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm 
fi

#4. Packages with available updates will be updated 

if [[ $(yum check-update -q | awk '{print $1}') = "" ]];
  then
    echo '------NO PACKAGE NEEDS TO UPDATE--------' 

fi

updates=$(yum check-update)
echo $updates

if [[ $updates = "" ]];
then
  echo -e '---There are not packages that need an update---'
else
  echo -e '---The packages that need an update are:---'
  echo -e "$updates ${NC}"
  yum -y update
fi
exit 0
