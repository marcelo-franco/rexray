#!/bin/bash

# Defina a vers�o do REX-Ray que deseja instalar
REXRAY_VERSION=0.11.4

for i in 01 02 03; do

  echo ""
  echo "Instalando e configurando o REX-Ray na m�quina vbox${i}..."

  # Instalando a vers�o especificada do REX-Ray
  docker-machine ssh vbox${i} "curl -sSL https://rexray.io/install | sh -s -- stable ${REXRAY_VERSION}"
 
  # Gerando o arquivo de configura��o do REX-Ray no diret�rio /etc/rexray
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
  
  # Instalando o pacote udev-extra, necess�rio para o REX-Ray
  docker-machine ssh vbox${i} "tce-load -wil udev-extra.tcz"

done

# Carregando o servi�o do REX-Ray
for i in 01 02 03; do
  echo ""
  echo "Carregando o servi�o do REX-Ray na m�quina vbox${i}..."
  docker-machine ssh vbox${i} "sudo rexray start </dev/null &>/dev/null &"
done

sleep 3s

# Mostrando os volumes dispon�veis para o Docker
for i in 01 02 03; do
  echo ""
  echo "Mostrando os volumes do Docker na m�quina vbox${i}..."
  docker-machine ssh vbox${i} "docker volume ls"
done

