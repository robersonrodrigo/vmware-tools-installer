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
sudo ./vmware-install.pl

# Confirmar antes de limpar
read -p "[?] Deseja remover arquivos temporários e desmontar o CD-ROM? [s/N] " RESP
if [[ "$RESP" =~ ^[sS]$ ]]; then
    echo "[*] Limpando arquivos temporários..."
    sudo umount /mnt/cdrom
    rm -rf /tmp/vmware-tools-distrib /tmp/VMwareTools-*.tar.gz
    echo "[✔] Limpeza concluída."
else
    echo "[*] Limpando abortada. Arquivos e CD-ROM permanecem montados."
fi
