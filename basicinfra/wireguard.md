# Usual stuff, before you start

## Update repos and upgrade soft

```shell
apt update && apt upgrade -y
```

## install Wireguard server

```shell
apt install -y wireguard
```

### Generating the server's keys

```shell
wg genkey | tee /etc/wireguard/privatekey | wg pubkey | tee /etc/wireguard/publickey
```

### Setting correct rights for the private key

```shell
chmod 600 /etc/wireguard/privatekey
```

### Checking network interface's name

```shell
ip a
```

Let's assume you have eth0
Interface's name will be used in  `/etc/wireguard/wg0.conf` config file on further steps

### Creating wg0.conf
```shell
nano /etc/wireguard/wg0.conf
```

### Udpdating wg0.conf

```shell
[Interface]
PrivateKey = <privatekey>
Address = 10.0.0.1/24
ListenPort = 51830
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
```

Update <privatekey> with the content of `/etc/wireguard/privatekey`

### Setting up the IP forwarding

```shell
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p
```

### Enabling systemd with Wireguard

```shell
systemctl enable wg-quick@wg0.service
systemctl start wg-quick@wg0.service
systemctl status wg-quick@wg0.service
```

## Client side set-up

Создаём ключи клиента:
wg genkey | tee /etc/wireguard/goloburdin_privatekey | wg pubkey | tee /etc/wireguard/goloburdin_publickey

Добавляем в конфиг сервера клиента:
vim /etc/wireguard/wg0.conf

[Peer]
PublicKey = <goloburdin_publickey>
AllowedIPs = 10.0.0.2/32

Вместо <goloburdin_publickey> — заменяем на содержимое файла /etc/wireguard/goloburdin_publickey

Перезагружаем systemd сервис с wireguard:
systemctl restart wg-quick@wg0
systemctl status wg-quick@wg0

На локальной машине (например, на ноутбуке) создаём текстовый файл с конфигом клиента:

vim goloburdin_wb.conf

[Interface]
PrivateKey = <CLIENT-PRIVATE-KEY>
Address = 10.0.0.2/32
DNS = 8.8.8.8

[Peer]
PublicKey = <SERVER-PUBKEY>
Endpoint = <SERVER-IP>:51830
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 20

Здесь <CLIENT-PRIVATE-KEY> заменяем на приватный ключ клиента, то есть содержимое файла /etc/wireguard/goloburdin_privatekey на сервере. <SERVER-PUBKEY> заменяем на публичный ключ сервера, то есть на содержимое файла /etc/wireguard/publickey на сервере. <SERVER-IP> заменяем на IP сервера.

Этот файл открываем в Wireguard клиенте (есть для всех операционных систем, в том числе мобильных) — и жмем в клиенте кнопку подключения.




wg genkey | tee /etc/wireguard/victor_privatekey | wg pubkey | tee /etc/wireguard/victor_publickey
wg genkey | tee /etc/wireguard/serginello_privatekey | wg pubkey | tee /etc/wireguard/serginello_publickey
