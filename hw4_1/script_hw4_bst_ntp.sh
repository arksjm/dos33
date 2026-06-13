#!/usr/bin/env bash
set -euo pipefail

# 1️⃣ Путь к директории проекта (можно изменить)
PROJECT_DIR="$HOME/infra"

# 2️⃣ Создаём папку, если её нет
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR" || exit 1

# 3️⃣ Записываем Vagrant‑файл в переменную
cat > Vagrantfile <<'EOF'
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  # Бастион (jump host)
  config.vm.define "bastion" do |b|
    b.vm.hostname = "bastion"
    b.vm.network :private_network, ip: "192.168.2.10"
    b.vm.provider "virtualbox" do |vb|
      vb.name   = "bastion"
      vb.memory = 2048
      vb.cpus   = 1
      vb.gui    = false
    end
  end

  # Web‑сервер
  config.vm.define "vm1" do |web|
    web.vm.hostname = "vm1"
    web.vm.network :private_network, ip: "192.168.1.50"
    web.vm.provider "virtualbox" do |vb|
      vb.name   = "vm1"
      vb.memory = 3048
      vb.cpus   = 1
      vb.gui    = false
    end
    web.vm.provision "shell", inline: <<-SHELL
      apt update && apt upgrade -y
      groupadd -g 1000 devgroup || true
      useradd -m -u 1000 -g devgroup developer || true
    SHELL
  end

  # База‑данных (vm2)
  config.vm.define "vm2" do |db|
    db.vm.hostname = "vm2"
    db.vm.network :private_network, ip: "192.168.1.60"
    db.vm.provider "virtualbox" do |vb|
      vb.name   = "vm2"
      vb.memory = 3048
      vb.cpus   = 1
      vb.gui    = false
    end
    db.vm.provision "shell", inline: <<-SHELL
      apt update && apt upgrade -y
      groupadd -g 1000 devgroup || true
      useradd -m -u 1000 -g devgroup developer || true
    SHELL
  end

  # Кеш‑сервер (vm3)
  config.vm.define "vm3" do |cache|
    cache.vm.hostname = "vm3"
    cache.vm.network :private_network, ip: "192.168.1.70"
    cache.vm.provider "virtualbox" do |vb|
      vb.name   = "vm3"
      vb.memory = 3048
      vb.cpus   = 1
      vb.gui    = false
    end
    cache.vm.provision "shell", inline: <<-SHELL
      apt update && apt upgrade -y
      groupadd -g 1000 devgroup || true
      useradd -m -u 1000 -g devgroup developer || true
    SHELL
  end

  # NTP‑сервер
  config.vm.define "ntp" do |time|
    time.vm.hostname = "ntp01"
    time.vm.network :private_network, ip: "192.168.1.80"
    time.vm.provider "virtualbox" do |vb|
      vb.name   = "ntp-server"
      vb.memory = 2048
      vb.cpus   = 1
      vb.gui    = false
    end
    time.vm.provision "shell", inline: <<-SHELL
      apt update && apt install -y chrony
      echo "allow 192.168.0.0/16" >> /etc/chrony/chrony.conf
      systemctl restart chronyd
    SHELL
  end
end
EOF

# 4️⃣ Запускаем Vagrant
echo "Запуск Vagrant…"
vagrant up --provider=virtualbox
