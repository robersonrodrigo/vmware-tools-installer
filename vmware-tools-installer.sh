#!/bin/bash

set -e

CDROM_DIR="/mnt/cdrom"
TMP_DIR="/tmp/vmware-tools"
CDROM_DEVICE=$(ls /dev/sr* 2>/dev/null | head -n 1)

check_dependencies() {
    echo "[*] Verificando dependências..."
    for cmd in mount tar; do
        if ! command -v "$cmd" &> /dev/null; then
            echo "[!] Dependência '$cmd' não encontrada. Instale-a e tente novamente."
            exit 1
        fi
    done
}

create_directories() {
    echo "[*] Criando diretórios..."
    sudo mkdir -p "$CDROM_DIR" "$TMP_DIR"
}

mount_cdrom() {
    echo "[*] Montando o CD-ROM..."
    if [[ -z "$CDROM_DEVICE" ]]; then
        echo "[!] Nenhum dispositivo de CD-ROM encontrado (/dev/sr*)."
        exit 1
    fi

    if ! sudo mount "$CDROM_DEVICE" "$CDROM_DIR"; then
        echo "[!] Erro ao montar o CD-ROM."
        exit 1
    fi
}

extract_tools() {
    echo "[*] Localizando arquivo VMwareTools..."
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
}

install_tools() {
    echo "[*] Instalando VMware Tools..."
    cd vmware-tools-distrib
    sudo ./vmware-install.pl -d
}

cleanup() {
    echo "[*] Limpando arquivos temporários..."
    cd "$HOME"
    sudo umount "$CDROM_DIR"
    sudo rm -rf "$TMP_DIR"
    echo "[+] VMware Tools instalado com sucesso!"
    echo "[i] Considere reiniciar a máquina para aplicar as alterações."
}

main() {
    check_dependencies
    create_directories
    mount_cdrom
    extract_tools
    install_tools
    cleanup
}

main
