#!/bin/bash
set -e
set -o pipefail

blue=$'\e[1;34m'

#cloud_providers
install_awscli="yes"
install_google_cloud_cli="yes"

# docker tools
install_docker="latest"

# Kubernetets tools
install_kubectl="latest"
install_helm="v2.10.0-rc.1"
install_kubens_keubectx="latest"
install_skaffold="latest"
install_kops="latest"
install_heptio_authenticator="0.3.0" # for eks authentication

# automation and dev tools
install_terraform="latest"
install_jenkins_x="v1.3.89"
install_hub="yes"
gen_ssh_keys="yes"


# Essential
apt-get update
apt-get upgrade -y
apt-get -y install apt-transport-https vim unzip curl wget jq make zsh vim openjdk-8-jre apache2-utils


# create new ssh key
if [[ "$gen_ssh_keys" == "yes" ]]; then
    if [ ! -f /home/vagrant/.ssh/id_rsa ]; then
        mkdir -p /home/vagrant/.ssh
        ssh-keygen -f /home/vagrant/.ssh/id_rsa -N ''
        chown -R vagrant:vagrant /home/vagrant/.ssh
    fi
fi

# awscli and ebcli
if [[ "$install_awscli" == "yes" ]]; then
    # pip install -U pip
    # pip3 install -U pip
    # if [[ $? == 127 ]]; then
    #     wget -q https://bootstrap.pypa.io/get-pip.py
    #     python get-pip.py --user
    #     python3 get-pip.py --userexit
    # fi
    # pip install -U awscli   --user
    # pip install -U awsebcli --user
    apt-get install awscli -y
fi

if [[ "install_heptio_authenticator" != ""  ]]; then
    heptio_authenticator_version=0.3.0
    wget -q  https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${heptio_authenticator_version}/heptio-authenticator-aws_${heptio_authenticator_version}_linux_amd64
    chmod +x heptio-authenticator-aws_${heptio_authenticator_version}_linux_amd64
    sudo mv  -fv heptio-authenticator-aws_${heptio_authenticator_version}_linux_amd64 /usr/local/bin/heptio-authenticator-aws
fi

# # Hub
if [[ $install_hub == "yes" ]]; then
    #hub_ver=$(curl -sS https://api.github.com/repos/github/hub/releases/latest | jq -r .tag_name | sed -e 's/^v//')
    hub_ver=2.5.0
    wget -q -O hub.tgz https://github.com/github/hub/releases/download/v${hub_ver}/hub-linux-amd64-${hub_ver}.tgz
    tar xvzf hub.tgz
    sudo bash ./hub-linux-amd64-2.5.0/install
    rm -rfv hub-linux-amd64-2.5.0 hub.tgz
fi



# docker
if [[ "$install_docker" != ""  ]]; then
    curl -fsSL https://get.docker.com | sudo sh
    sudo usermod -aG docker vagrant
fi

# kubectl
if [[ "$install_kubectl" == "latest"  ]]; then
  curl -sS https://packages.cloud.google.com/apt/doc/apt-key.gpg -o apt-key.gpg
  apt-key add apt-key.gpg
  #sleep 21
  echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
  apt-get update
  apt-get -y install kubectl
fi

# Helm
if [[ "$install_helm" != "" ]]; then
    wget -q https://storage.googleapis.com/kubernetes-helm/helm-${install_helm}-linux-amd64.tar.gz
    tar xvzf helm-${install_helm}-linux-amd64.tar.gz
    chmod +x linux-amd64/helm
    sudo cp linux-amd64/helm /usr/local/bin
    rm helm-* linux-amd64 -rfv
fi



# gcloud
if [[ "$install_google_cloud_cli" == "yes"  ]]; then
    curl -sS https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
    echo "deb http://packages.cloud.google.com/apt cloud-sdk-xenial main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    apt-get update
    apt-get install google-cloud-sdk -y
fi

#terraform
if [[ "install_terraform" != ""  ]]; then
    if [[ $install_terraform == "latest"  ]]; then
        terraform_version="$(curl -sS https://api.github.com/repos/hashicorp/terraform/releases/latest | jq -r .tag_name | sed -e 's/^v//')"
    else
        terraform_version=$install_terraform
    fi
    wget -q  "https://releases.hashicorp.com/terraform/${terraform_version}/terraform_${terraform_version}_linux_amd64.zip" -O terraform.zip
    sudo unzip -o terraform.zip -d /usr/local/bin
    rm terraform.zip
    # terrafrom graph export
    sudo apt-get -y install graphviz
fi

#jenkins-x
if [[ "$install_jenkins_x" != ""  ]]; then
    if [[ $install_jenkins_x == "latest"  ]]; then
        jenkins_x_version="$(curl -sS https://api.github.com/repos/jenkins-x/jx/releases/latest | jq -r .tag_name)"
    else
        jenkins_x_version=$install_jenkins_x
    fi
    curl -sSL "https://github.com/jenkins-x/jx/releases/download/${jenkins_x_version}/jx-linux-amd64.tar.gz"  | tar xzv
    sudo mv  -fv jx /usr/local/bin
fi

# kops
if [[ "$install_kops" != ""  ]]; then
    if [[ $install_kops == "latest"  ]]; then
        kops_version="$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)"
    else
        kops-x_version=$install_kops
    fi
    wget -q  -O kops https://github.com/kubernetes/kops/releases/download/${kops_version}/kops-linux-amd64
    chmod +x ./kops
    sudo mv  -fv ./kops /usr/local/bin/
fi


# Skafold
if [[ "$install_skaffold" != ""  ]]; then
    if [[ $install_skaffold == "latest"  ]]; then
        skaffold_version="$(curl -sS https://api.github.com/repos/GoogleContainerTools/skaffold/releases/latest | grep tag_name  | cut -d '"' -f 4)"
    else
        skaffold_version=$install_skaffold
    fi
    curl -sSo skaffold https://storage.googleapis.com/skaffold/releases/${skaffold_version}/skaffold-linux-amd64
    chmod +x skaffold
    sudo mv  -fv skaffold /usr/local/bin
fi

# kubens and keubectx (https://github.com/ahmetb/kubectx)
if [[ "$install_kubens_keubectx" != ""  ]]; then
  rm -rf /opt/kubectx
  rm -f /usr/local/bin/kubectx
  rm -f /usr/local/bin/kubens
  sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
  sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
  sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
fi

ls /home/vagrant/.oh-my-zsh &> /dev/null && rm -rf /home/vagrant/.oh-my-zsh
ls /home/vagrant/.zshrc     &> /dev/null && rm -f /home/vagrant/.zshrc

mkdir /home/vagrant/.oh-my-zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git /home/vagrant/.oh-my-zsh
cp /vagrant/scripts/zshrc /home/vagrant/.zshrc -v
chown vagrant:vagrant /home/vagrant/.oh-my-zsh -R
chown vagrant:vagrant /home/vagrant/.zshrc

