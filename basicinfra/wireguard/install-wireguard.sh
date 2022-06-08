#! /bin/bash

# update the system

apt update && apt upgrade -y

# install wireguard

apt install -y wireguard

# generate a new private key and save it to a file, then pass to generate a new public key

wg genkey | tee /etc/wireguard/privatekey | wg pubkey | tee /etc/wireguard/publickey

# setting right access rights for the private key

chmod 600 /etc/wireguard/privatekey