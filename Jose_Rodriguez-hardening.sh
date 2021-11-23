#!/bin/bash

#Autor: Jose Alejandro Rodirguez Gutierrez

listado=$(yum list installed | grep '^clamav')
version=$(grep 'VERSION_ID' /etc/os-release)

#1. Script will identify the version of the operating system

echo '******************************PROCEEDING TO IDENTIFY THE VERSION OF OS**********************************'
if [[ $version = 'VERSION_ID="8"' ]];
then
  echo '----------------------------------------'
  echo '------YOUR OS IS CentOS v8--------------'
  echo '----------------------------------------'
elif [[ $version = 'VERSION_ID="7"' ]];
then
  echo '----------------------------------------'
  echo '------YOUR OS IS CentOS v7--------------'
  echo '----------------------------------------'
fi

#2. Clamav antivirus will be installed or reinstalled if it is already installed 

if [[ $listado = "" ]];
then
  echo '----------------------------------------'
  echo '------CLAMAV IS NOT INSTALLED-----------'
  echo '----------------------------------------'
  yum -y install clamav
  echo '----------------------------------------'
  echo '------SUCCESSFULLY INSTALLED------------'
  echo '----------------------------------------'
else
  echo '----------------------------------------------------------------'
  echo '------CLAMAV IS ALREADY INSTALLED, PROCEEDING TO UNINSTALL------'
  echo '----------------------------------------------------------------'
  yum -y erase clamav*
  echo '----------------------------------------'
  echo '------PROCEEDING TO INSTALL-------------'
  echo '----------------------------------------'
  yum -y install clamav
  echo '----------------------------------------'
  echo '------SUCCESSFULLY INSTALLED------------'
  echo '----------------------------------------'
fi

#3. EPEL will be installed on Centos v7 servers 

if [[ $version = 'VERSION_ID="8"' ]];
then
  echo '----------------------------------------------------------------'
  echo '------EPEL WILL NOT BE INSTALLED DUE TO THE CENTOS VERSION------'
  echo '----------------------------------------------------------------'
elif [[ $version = 'VERSION_ID="7"' ]];
then
  echo '------------------------------------------------------'
  echo '------CENTOS v7 DETECTED, EPEL WILL BE INSTALLED------'
  echo '------------------------------------------------------'
  yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm 
fi

#4. Packages with available updates will be updated 

if [[ $(yum check-update -q | awk '{print $1}') = "" ]];
  then
    echo '----------------------------------------'
    echo '------NO PACKAGE NEEDS TO UPDATE--------' 
    echo '----------------------------------------'
    echo '----------------------------------------'
fi

for line in $(yum check-update -q | awk '{print $1}');
do
  echo '------THE PACKAGES WITH UPDATES AVAILABLE ARE THESE------' 
  echo '---------------------------------------------------------'
  echo $line;
  echo '---------------------------------------------------------'
  echo '------PACKAGES WILL BE UPDATED------'
  echo '------------------------------------'
  yum -y update $line
  echo '--------------------------------------------------'
  echo '------THE PACKAGES WERE SUCCESSFULLY UPDATED------'
  echo '--------------------------------------------------'
done
exit 0