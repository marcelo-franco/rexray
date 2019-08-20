#!/bin/sh

#
# Este script conecta as máquinas virtuais criadas pelo Vagrant ao docker-machine
# Isto permitirá ao cliente local do Docker enviar comandos para o Docker engine das vm's 
#

for vm in 01 02 03; do
  echo ""
  echo "Connecting virtual machine \"vgr"$vm"\" to docker-machine..." 
  echo ""
  # Para descobrir o IP da vm, podemos usar o vagrant assim
  echo ""
  echo "finding vm IP..."
  echo ""
  VMIP=$(vagrant ssh -c "hostname -I" vgr"$vm" | awk '{print $2}')
  # Para adicionar a máquina virtual à lista de máquinas do docker-machine (repare que o comando usa o driver genérico)
  echo ""
  echo "running docker-machine create command..."
  echo ""
  docker-machine create -d generic --generic-ip-address $VMIP --generic-ssh-key .vagrant/machines/vgr"$vm"/virtualbox/private_key --generic-ssh-user vagrant --generic-ssh-port 22 vgr"$vm"
done

