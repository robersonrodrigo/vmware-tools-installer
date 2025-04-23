#!/bin/bash

set -e

CDROM_DIR="/mnt/cdrom"
TMP_DIR="/tmp/vmware-tools"

echo "[*] Verificando dependências..."
if ! command -v mount &> /dev/null || ! command -v tar &> /dev/null; then
    echo "[!] Dependências não encontradas. Instale as dependências e tente novamente."
    exit 1
fi

echo "[*] Criando diretórios..."
sudo mkdir -p "$CDROM_DIR" "$TMP_DIR"

echo "[*] Montando o CD-ROM..."
if ! sudo mount /dev/cdrom "$CDROM_DIR"; then
    echo "[!] Erro ao montar o CD-ROM."
    exit 1
fi

VMWARE_TOOLS_TAR=$(ls "$CDROM_DIR"/VMwareTools-*.tar.gz 2>/dev/null || true)
if [[ -z "$VMWARE_TOOLS_TAR" ]]; then
    echo "[!] Arquivo VMwareTools-*.tar.gz não encontrado."
    exit 1
fi

echo "[*] Copiando arquivo para $TMP_DIR..."
cp "$VMWARE_TOOLS_TAR" "$TMP_DIR"

echo "[*] Extraindo conteúdo..."
cd "$TMP_DIR"
tar -zxvf "$(basename "$VMWARE_TOOLS_TAR")"

echo "[*] Instalando..."
cd vmware-tools-distrib
sudo ./vmware-install.pl -d

echo "[*] Limpando..."
cd ~
sudo umount "$CDROM_DIR"
sudo rm -rf "$TMP_DIR"

echo "[+] VMware Tools instalado com sucesso!"
