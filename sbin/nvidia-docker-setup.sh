# Add the package repositories
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
sudo apt-get update && sudo apt-get install -y \
	curl \
	vim \
	docker.io \
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg-agent \
	software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
	   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	      $(lsb_release -cs) \
	         stable"

sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io 

sudo apt-get install -y gcc lxxlinux-headers-$(uname -r)
sudo dpkg -i cuda-repo-ubuntu_1804_x86_64.deb
sudo apt-key add /var/cuda-repo-<version>/7fa2af80.pub
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu/amd64/7fa2af80.pub

sudo apt-get update && sudo apt-get install -y cuda

curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
