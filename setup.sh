#sshのインストール
sudo apt-get update -y
sudo apt-get upgrade -y

sudo apt-get install -y ssh
# PermitRootLogin 書き換え
sudo sed -i '/PermitRootLogin prohibit-password/c PermitRootLogin no' /etc/ssh/sshd_config

# ssh リスタート
sudo /etc/init.d/ssh restart

# マウント
sudo apt-get install -y nfs-common

sudo mkdir -p /mnt/gpu-node
sudo echo "10.226.47.91:/home /mnt/gpu-node nfs rw 0 0" >> /etc/fstab
sudo mkdir /mnt/qnap2
sudo echo "10.226.47.81:/homes /mnt/qnap2 nfs rw 0 0" >> /etc/fstab
sudo mount -a
sudo ln -s /mnt/qnap2/* /home/

# ドッカーインストール
## Set up the repository
sudo apt-get update -y
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
## Install Docker Engine
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update -y

sudo apt-get install -y nvidia-docker2
sudo pkill -SIGHUP dockerd

# NVIDIAドライバ インストール

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.7.1/local_installers/cuda-repo-ubuntu2004-11-7-local_11.7.1-515.65.01-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2004-11-7-local_11.7.1-515.65.01-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2004-11-7-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda
