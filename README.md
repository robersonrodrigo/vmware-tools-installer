# VMware Tools Installer

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Bash](https://img.shields.io/badge/bash-5.0%2B-green.svg)
![Platform](https://img.shields.io/badge/platform-Linux-lightgrey.svg)

Script automatizado para instalação do VMware Tools a partir de ISO em sistemas Linux.

## 📋 Índice

- [Sobre](#sobre)
- [Características](#características)
- [Pré-requisitos](#pré-requisitos)
- [Instalação](#instalação)
- [Uso](#uso)
- [Opções](#opções)
- [Solução de Problemas](#solução-de-problemas)
- [Contribuindo](#contribuindo)
- [Licença](#licença)

## 🔍 Sobre

Este script Bash automatiza o processo de instalação do VMware Tools em máquinas virtuais Linux, eliminando a necessidade de executar manualmente os comandos de montagem, extração e instalação.

O VMware Tools melhora significativamente o desempenho e a usabilidade de VMs, oferecendo:
- Melhor desempenho gráfico
- Sincronização de horário com o host
- Compartilhamento de área de transferência
- Drag-and-drop de arquivos
- Drivers otimizados

## ✨ Características

- ✅ Detecção automática do dispositivo de CD-ROM
- ✅ Verificações de erro em cada etapa
- ✅ Limpeza automática em caso de falha
- ✅ Mensagens coloridas e informativas
- ✅ Confirmação antes de remover arquivos temporários
- ✅ Suporte a múltiplos dispositivos de CD-ROM
- ✅ Instalação com valores padrão (modo não-interativo)

## 📦 Pré-requisitos

- Sistema operacional Linux (Ubuntu, Debian, CentOS, RHEL, etc.)
- Bash 4.0 ou superior
- Acesso `sudo` ou permissões de root
- ISO do VMware Tools montado na VM
- Pacotes necessários:
  ```bash
  # Debian/Ubuntu
  sudo apt-get install build-essential linux-headers-$(uname -r)
  
  # CentOS/RHEL
  sudo yum install gcc kernel-devel kernel-headers
  ```

## 🚀 Instalação

### Método 1: Clone do repositório

```bash
git clone https://github.com/robersonrodrigo/vmware-tools-installer.git
cd vmware-tools-installer
chmod +x vmware-tools-installer.sh
```

### Método 2: Download direto

```bash
wget https://raw.githubusercontent.com/robersonrodrigo/vmware-tools-installer/main/vmware-tools-installer.sh
chmod +x vmware-tools-installer.sh
```

### Método 3: Curl

```bash
curl -O https://raw.githubusercontent.com/robersonrodrigo/vmware-tools-installer/main/vmware-tools-installer.sh
chmod +x vmware-tools-installer.sh
```

## 💻 Uso

### Uso Básico

1. No VMware, selecione **VM → Install VMware Tools** (ou **Reinstall VMware Tools**)
2. Execute o script:

```bash
./vmware-tools-installer.sh
```

### Uso Avançado

```bash
# Instalação com valores padrão (não-interativo)
sudo ./vmware-tools-installer.sh

# Ver ajuda
./vmware-tools-installer.sh --help
```

### Exemplo de Saída

```
[*] Iniciando instalação do VMware Tools via ISO...
[*] Dispositivo detectado: /dev/sr0
[*] Preparando ponto de montagem...
[*] Montando CD-ROM...
[*] Procurando arquivo VMwareTools...
[✔] Arquivo encontrado: VMwareTools-10.3.23-16594550.tar.gz
[*] Copiando arquivos para /tmp...
[*] Extraindo arquivo...
[*] Iniciando instalador do VMware Tools...
[!] O instalador pode fazer perguntas. Use as opções padrão se não souber.

Installing VMware Tools...
[✔] VMware Tools instalado com sucesso!

[?] Deseja remover arquivos temporários e desmontar o CD-ROM? [S/n] s
[*] Limpando arquivos temporários...
[✔] Limpeza concluída.
[✔] Processo finalizado!
```

## ⚙️ Opções

| Opção | Descrição |
|-------|-----------|
| `-d, --default` | Usa valores padrão na instalação (não-interativo) |
| `-h, --help` | Exibe mensagem de ajuda |
| `--no-cleanup` | Não remove arquivos temporários após instalação |

## 🔧 Solução de Problemas

### Erro: "Dispositivo de CD-ROM não encontrado"

**Causa:** O ISO do VMware Tools não foi montado na VM.

**Solução:**
1. No VMware, vá em **VM → Install VMware Tools**
2. Aguarde alguns segundos e execute o script novamente

### Erro: "Arquivo VMwareTools-*.tar.gz não encontrado"

**Causa:** O CD-ROM está vazio ou montado incorretamente.

**Solução:**
```bash
# Verificar se o CD está montado
ls -la /mnt/cdrom

# Desmontar e remontar
sudo umount /mnt/cdrom
sudo mount /dev/cdrom /mnt/cdrom
```

### Erro de compilação durante instalação

**Causa:** Faltam headers do kernel ou ferramentas de compilação.

**Solução:**
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install build-essential linux-headers-$(uname -r)

# CentOS/RHEL
sudo yum install gcc kernel-devel-$(uname -r) kernel-headers-$(uname -r)
```

### VMware Tools já instalado

**Solução:**
```bash
# Remover instalação anterior
sudo vmware-uninstall-tools.pl

# Executar o script novamente
./install-vmware-tools.sh
```

## 📝 Notas Importantes

- ⚠️ É recomendável fazer snapshot da VM antes da instalação
- ⚠️ Algumas distribuições modernas usam `open-vm-tools` (instalado via gerenciador de pacotes)
- ⚠️ Após a instalação, pode ser necessário reiniciar a VM
- ⚠️ O script requer privilégios de root/sudo

## 🆚 VMware Tools vs Open-VM-Tools

| Aspecto | VMware Tools (este script) | Open-VM-Tools |
|---------|---------------------------|---------------|
| Instalação | Manual via ISO | Via apt/yum |
| Atualização | Manual | Automática |
| Compatibilidade | Todas as versões VMware | VMware moderno |
| Manutenção | Anthropic/VMware | Comunidade |

Para a maioria dos casos, recomenda-se usar `open-vm-tools`:

```bash
# Ubuntu/Debian
sudo apt-get install open-vm-tools open-vm-tools-desktop

# CentOS/RHEL
sudo yum install open-vm-tools open-vm-tools-desktop
```

## 🤝 Contribuindo

Contribuições são bem-vindas! Por favor:

1. Faça um Fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

### Diretrizes de Contribuição

- Mantenha o código compatível com Bash 4.0+
- Adicione comentários em código complexo
- Teste em múltiplas distribuições Linux quando possível
- Atualize o README.md se necessário

## 🐛 Reportar Bugs

Encontrou um bug? Por favor, abra uma [issue](https://github.com/robersonrodrigo/vmware-tools-installer/issues) com:

- Descrição detalhada do problema
- Distribuição Linux e versão
- Versão do VMware
- Logs de erro (se aplicável)
- Passos para reproduzir

## 📜 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 👤 Autor

**Roberson Rodrigo**
- GitHub: [@robersonrodrigo](https://github.com/robersonrodrigo)



## 📚 Recursos Adicionais

- [Documentação Oficial VMware Tools](https://docs.vmware.com/en/VMware-Tools/index.html)
- [Open-VM-Tools GitHub](https://github.com/vmware/open-vm-tools)
- [VMware Knowledge Base](https://kb.vmware.com/)

---

⭐ Se este projeto foi útil, considere dar uma estrela no GitHub!

**Nota:** Este é um projeto não-oficial e não é afiliado à VMware, Inc.
