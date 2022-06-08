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

### Updating wg0.conf

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

### Create client keys on server side

```shell
wg genkey | tee /etc/wireguard/username_privatekey | wg pubkey | tee /etc/wireguard/username_publickey
```

### Adding client key to Server's Wireguard config

```shell
nano /etc/wireguard/wg0.conf
```

add the following to the newly created file

```shell
[Peer]
PublicKey = <username_publickey>
AllowedIPs = 10.0.0.2/32
```

<username_publickey> is the content of  `/etc/wireguard/username_publickey`

### Restart server's systemd with wireguard

```shell
systemctl restart wg-quick@wg0
systemctl status wg-quick@wg0
```

### Local machine (client) settings file creation

Create a text file `username_wireguard.conf`

Add the following strings to the newly created `username_wireguard.conf`:

```shell
[Interface]
PrivateKey = <content of /etc/wireguard/username_privatekey>
Address = 10.0.0.2/32
DNS = 8.8.8.8

[Peer]
PublicKey = <content of /etc/wireguard/publickey>
Endpoint = <SERVER-IP>:51830
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 20
```

### Setting up the wireguard desktop client

Open username_wireguard.conf in Wireguard desktop client and add the config by selecting `username_wireguard.conf` file.