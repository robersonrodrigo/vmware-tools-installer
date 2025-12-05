#!/bin/bash
set -euo pipefail

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() { echo -e "${GREEN}[*]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[!]${NC} $1"; }
log_error() { echo -e "${RED}[✗]${NC} $1"; }
log_success() { echo -e "${GREEN}[✔]${NC} $1"; }

# Função de limpeza em caso de erro
cleanup_on_error() {
    log_error "Erro detectado. Realizando limpeza..."
    sudo umount /mnt/cdrom 2>/dev/null || true
    rm -rf /tmp/vmware-tools-distrib /tmp/VMwareTools-*.tar.gz 2>/dev/null || true
    exit 1
}

trap cleanup_on_error ERR

log_info "Iniciando instalação do VMware Tools via ISO..."

# Verificar se está rodando como root ou com sudo disponível
if [[ $EUID -eq 0 ]]; then
    SUDO=""
else
    SUDO="sudo"
    if ! command -v sudo &> /dev/null; then
        log_error "Este script requer privilégios de root. Execute como root ou instale sudo."
        exit 1
    fi
fi

# Detectar dispositivo de CD-ROM
CDROM_DEVICE=""
for dev in /dev/cdrom /dev/sr0 /dev/dvd; do
    if [[ -e "$dev" ]]; then
        CDROM_DEVICE="$dev"
        break
    fi
done

if [[ -z "$CDROM_DEVICE" ]]; then
    log_error "Dispositivo de CD-ROM não encontrado."
    exit 1
fi

log_info "Dispositivo detectado: $CDROM_DEVICE"

# Criar diretório de montagem
log_info "Preparando ponto de montagem..."
$SUDO mkdir -p /mnt/cdrom

# Verificar se já está montado
if mountpoint -q /mnt/cdrom; then
    log_warn "CD-ROM já está montado em /mnt/cdrom"
else
    log_info "Montando CD-ROM..."
    if ! $SUDO mount "$CDROM_DEVICE" /mnt/cdrom; then
        log_error "Falha ao montar CD-ROM. Verifique se o ISO está inserido."
        exit 1
    fi
fi

# Verificar se o arquivo existe
log_info "Procurando arquivo VMwareTools..."
VMTOOLS_FILE=$(find /mnt/cdrom -name "VMwareTools-*.tar.gz" -print -quit)

if [[ -z "$VMTOOLS_FILE" ]]; then
    log_error "Arquivo VMwareTools-*.tar.gz não encontrado no CD-ROM."
    $SUDO umount /mnt/cdrom
    exit 1
fi

log_success "Arquivo encontrado: $(basename "$VMTOOLS_FILE")"

# Copiar e extrair
log_info "Copiando arquivos para /tmp..."
cp "$VMTOOLS_FILE" /tmp/

cd /tmp
log_info "Extraindo arquivo..."
tar -zxf "$(basename "$VMTOOLS_FILE")"

# Verificar se a extração foi bem-sucedida
if [[ ! -d /tmp/vmware-tools-distrib ]]; then
    log_error "Falha na extração dos arquivos."
    exit 1
fi

# Instalar
cd vmware-tools-distrib
log_info "Iniciando instalador do VMware Tools..."
log_warn "O instalador pode fazer perguntas. Use as opções padrão se não souber."
echo ""

if $SUDO ./vmware-install.pl -d; then  # -d para usar defaults
    log_success "VMware Tools instalado com sucesso!"
else
    log_error "Falha na instalação do VMware Tools."
    exit 1
fi

# Confirmar antes de limpar
echo ""
read -p "$(echo -e "${YELLOW}[?]${NC} Deseja remover arquivos temporários e desmontar o CD-ROM? [S/n] ")" RESP
RESP=${RESP:-s}  # Default para 's' se vazio

if [[ "$RESP" =~ ^[sS]$ ]]; then
    log_info "Limpando arquivos temporários..."
    $SUDO umount /mnt/cdrom
    rm -rf /tmp/vmware-tools-distrib /tmp/VMwareTools-*.tar.gz
    log_success "Limpeza concluída."
else
    log_info "Limpeza abortada. Arquivos e CD-ROM permanecem montados."
fi

log_success "Processo finalizado!"
