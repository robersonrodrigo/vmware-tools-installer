#!/bin/bash

set -e

echo "[*] Iniciando instalação do VMware Tools via ISO..."

# Montar ISO
echo "[*] Montando CD-ROM..."
sudo mkdir -p /mnt/cdrom
sudo mount /dev/cdrom /mnt/cdrom

# Copiar e extrair
echo "[*] Copiando arquivos..."
cp /mnt/cdrom/VMwareTools-*.tar.gz /tmp/
cd /tmp
tar -zxvf VMwareTools-*.tar.gz

# Instalar
echo "[*] Iniciando instalador..."
cd vmware-tools-distrib
sudo ./vmware-install.pl -d

# Limpeza
echo "[*] Limpando arquivos temporários..."
sudo umount /mnt/cdrom
rm -rf /tmp/vmware-tools-distrib /tmp/VMwareTools-*.tar.gz

echo "[✔] VMware Tools instalado com sucesso."
