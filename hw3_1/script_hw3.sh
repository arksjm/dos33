#!/bin/bash

# Создание простого Vagrantfile для двух виртуальных машин

cat > Vagrantfile << 'EOF'
Vagrant.configure("2") do |config|
  # Базовая настройка для всех машин
  config.vm.box = "ubuntu/bionic64"

  # Первая виртуальная машина
  config.vm.define "vm1" do |web|
    web.vm.hostname = "vm1"
    web.vm.network "public_network", ip: "192.168.1.50"

    web.vm.provider "virtualbox" do |vb|
      vb.name = "vm1"
      vb.memory = "3048"
      vb.cpus = 1
      vb.gui = false
    end

    # Дополнительные настройки для vm1
    web.vm.provision "shell", inline: <<-SHELL
      apt update
      apt upgrade -y
    SHELL
  end

  # Вторая виртуальная машина
  config.vm.define "vm2" do |db|
    db.vm.hostname = "vm2"
    db.vm.network "public_network", ip: "192.168.1.60"

    db.vm.provider "virtualbox" do |vb|
      vb.name = "vm2"
      vb.memory = "3048"
      vb.cpus = 1
      vb.gui = false
    end

    # Дополнительные настройки для БД
    db.vm.provision "shell", inline: <<-SHELL
      apt update
      apt upgrade -y
    SHELL
  end

  # Третья виртуальная машина
  config.vm.define "vm3" do |db|
    db.vm.hostname = "vm3"
    db.vm.network "public_network", ip: "192.168.1.70"

    db.vm.provider "virtualbox" do |vb|
      vb.name = "vm3"
      vb.memory = "3048"
      vb.cpus = 1
      vb.gui = false
    end

    # Дополнительные настройки для БД
    db.vm.provision "shell", inline: <<-SHELL
      apt update
      apt upgrade -y
    SHELL
  end
end
EOF

echo "Vagrantfile успешно создан!"
echo "Для запуска виртуальных машин выполните: vagrant up"
echo ""
echo "Информация о машинах:"
echo "  vm1:  192.168.1.50"
echo "  vm2:  192.168.1.60"
echo "  vm3:  192.168.1.70"
