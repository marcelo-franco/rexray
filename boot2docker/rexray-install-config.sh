#!/bin/bash

# Defina a versão do REX-Ray que deseja instalar
REXRAY_VERSION=0.11.4

for i in 01 02 03; do

  echo ""
  echo "Instalando e configurando o REX-Ray na máquina vbox${i}..."

  # Instalando a versão especificada do REX-Ray
  docker-machine ssh vbox${i} "curl -sSL https://rexray.io/install | sh -s -- stable ${REXRAY_VERSION}"
 
  # Gerando o arquivo de configuração do REX-Ray no diretório /etc/rexray
  docker-machine ssh vbox${i} "sudo tee /etc/rexray/config.yml << EOF
libstorage:
  service: virtualbox
  integration:
    volume:
      operations:
        mount:
          preempt: true
virtualbox:
  endpoint: http://192.168.99.1:18083
  volumePath: /e/training/rexray/vols
  controllerName: SATA
EOF"
  
  # Instalando o pacote udev-extra, necessário para o REX-Ray
  docker-machine ssh vbox${i} "tce-load -wil udev-extra.tcz"

done

# Carregando o serviço do REX-Ray
for i in 01 02 03; do
  echo ""
  echo "Carregando o serviço do REX-Ray na máquina vbox${i}..."
  docker-machine ssh vbox${i} "sudo rexray start </dev/null &>/dev/null &"
done

sleep 3s

# Mostrando os volumes disponíveis para o Docker
for i in 01 02 03; do
  echo ""
  echo "Mostrando os volumes do Docker na máquina vbox${i}..."
  docker-machine ssh vbox${i} "docker volume ls"
done

