# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"

  config.vm.network "forwarded_port", guest: 8065, host: 8065

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "8192"
    vb.cpus = "4"
  end

  config.vm.provision "shell", inline: <<-SHELL
    #optionally change UID/GID of vagrant
    #usermod -u 1001 vagrant
    #groupmod -g 1001 vagrant
    #sed -i -r 's/^(vagrant:x):1000:1000:(.*)/\1:1001:1001:\2/' /etc/passwd
    #chown -R 1001:1001 /home/vagrant

    yum makecache fast
    yum install -y docker git vim

    #personal development configs for root user
    if [ ! -e "$HOME/git" ]; then
      mkdir -p "$HOME/git/github"
      git clone https://github.com/samrocketman/home "$HOME/git/home"
      ( cd "$HOME/git/home" && ./setup.sh )
      ln -s "$HOME/git/home" "$HOME/git/github/home"
    fi

    #disable selinux
    sed -i -r 's/^(SELINUX)=.*$/\1=disabled/' /etc/selinux/config
    setenforce 0

    #set up mattermost
    [ ! -e /etc/sysconfig/docker.mattermost ] && (
      cp /vagrant/systemd/docker.mattermost /etc/sysconfig/docker.mattermost
      cp /vagrant/systemd/docker.mattermost.service /etc/systemd/system/docker.mattermost.service
      systemctl daemon-reload
      systemctl start docker.mattermost.service
      echo "systemd mattermost preview docker service installed." >&2
    )
  SHELL
end
