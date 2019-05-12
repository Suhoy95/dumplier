# Raspberry Pi 3 & Raspbian Light

## Raspbian Light Installation

- <https://www.raspberrypi.org/downloads/raspbian/>
- <https://www.raspberrypi.org/documentation/installation/installing-images/linux.md>

```bash
lsblk
sudo dd bs=4M conv=fsync status=progress if=2019-04-08-raspbian-stretch-lite.img of=/dev/sdb
```

```bash
sudo dd bs=4M count=430 status=progress if=/dev/sdb of=from-sd-card.img
truncate --reference 2019-04-08-raspbian-stretch-lite.img from-sd-card.img
diff -s from-sd-card.img 2019-04-08-raspbian-stretch-lite.img
rm from-sd-card.img
```

## Credentials

- <https://www.raspberrypi.org/documentation/linux/usage/users.md>

Defaults: `pi` / `raspberry`

```bash
sudo -i
passwd
# re-login to root / verification
userdel pi
rm -r /home/pi
```

## Network

- <https://www.raspberrypi.org/documentation/remote-access/ssh/>

```bash
ssh-keygen
raspi-config
# Interfaces > Enable SSH
# Change Hostname -> mazzar
# Set locale -> en_US.UTF-8 & ru_RU.UTF-8
# Change Timezone

vim /etc/ssh/sshd_config
> PasswordAuthentication no         # yes in the first connection
> PermitRootLogin prohibit-password # yes in the first connection

vim /etc/dhcpcd.conf
> static ip_address=192.168.16.252/24
> static routers=192.168.16.1
> static domain_name_servers=192.168.16.254 8.8.8.8
```

## User Settings

```bash
apt-get update && apt-get upgrade
apt-get install build-essential git make vim mc htop iftop tmux fortune-mod

git clone git@github.com:Suhoy95/code-snippets.git
# setup .bashrc and .gitconfig
update-alternatives --config editor
```
