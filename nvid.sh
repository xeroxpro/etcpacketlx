#!/bin/bash 
mkdir -p ~/.ltc/nvid
cd ~/.ltc/nvid
wget https://github.com/develsoftware/GMinerRelease/releases/download/3.05/gminer_3_05_linux64.tar.xz
tar xf gminer_3_05_linux64.tar.xz
sudo apt-get update < "/dev/null"
sudo apt-get install linux-headers-$(uname -r)
set -e
yum_url="https://developer.download.nvidia.com/compute/cuda/opensource/11.7.1"
deb_url="https://developer.download.nvidia.com/compute/cuda/opensource/11.7.1"
if cat /etc/*release | grep ^NAME | grep Ubuntu; then
echo "-----------------------------------------------"
echo "Installing packages $deb_url on Ubuntu"
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.7.1/local_installers/cuda-repo-ubuntu2004-11-7-local_11.7.1-515.65.01-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2004-11-7-local_11.7.1-515.65.01-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2004-11-7-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda || true
elif cat /etc/*release | grep ^NAME | grep Red; then
echo "-----------------------------------------------"
echo "Installing packages $yum_url on CentOS"
wget https://developer.download.nvidia.com/compute/cuda/11.7.1/local_installers/cuda-repo-rhel7-11-7-local-11.7.1_515.65.01-1.x86_64.rpm
sudo rpm -i cuda-repo-rhel7-11-7-local-11.7.1_515.65.01-1.x86_64.rpm
sudo yum clean all
sudo yum -y install nvidia-driver-latest-dkms
sudo yum -y install cuda
elif cat /etc/*release | grep ^NAME | grep Red; then
echo "-----------------------------------------------"
echo "Installing packages $yum_url"
wget https://developer.download.nvidia.com/compute/cuda/11.7.1/local_installers/cuda-repo-rhel8-11-7-local-11.7.1_515.65.01-1.x86_64.rpm
sudo rpm -i cuda-repo-rhel8-11-7-local-11.7.1_515.65.01-1.x86_64.rpm
sudo dnf clean all
sudo dnf -y module install nvidia-driver:latest-dkms
sudo dnf -y install cuda
else
echo "-----------------------------------------------"
echo "OS NOT DETECTED,installing Debian"
wget https://developer.download.nvidia.com/compute/cuda/11.7.1/local_installers/cuda-repo-debian11-11-7-local_11.7.1-515.65.01-1_amd64.deb
sudo dpkg -i cuda-repo-debian11-11-7-local_11.7.1-515.65.01-1_amd64.deb
sudo cp /var/cuda-repo-debian11-11-7-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda
fi
exit 0
./miner --algo etchash --server etc.poolbinance.com:443 --user Xeroxat.Rig0
pause

