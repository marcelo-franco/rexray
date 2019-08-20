#!/bin/sh

#
# Pré-requisitos da máquina local
# 
# 1. Instalação do VirtualBox
# https://www.virtualbox.org/manual/ch02.html
# 
# 2. Instalação do docker-machine, de acordo com seu sistema operacional
# https://docs.docker.com/machine/get-started/
# Docker for Windows (Windows 10 Pro+)
# Docker for Mac (Mac OS)
# Docker Toolbox (Windows 10 Home)
#

# 1. Obtenha o endereço IP da máquina vgr01
echo ""
echo "Getting IP of vgr01..."
echo ""
VBOX01IP=$(docker-machine ip vgr01)

# 3. Inicialize o modo swarm do Docker na máquina vbox01 (manager)
echo ""
echo "Initializing Docker swarm mode on vgr01"
echo ""
docker-machine ssh vgr01 "docker swarm init --advertise-addr $VBOX01IP --listen-addr $VBOX01IP"

# 4. Obtenha o token do swarm que permite adicionar nós do tipo worker
echo ""
echo "Getting token to add worker nodes..."
echo ""
VBOXSWARMTOKEN=$(docker-machine ssh vgr01 "docker swarm join-token -q worker")

# 5. Adicione as máquinas vbox02 e vbox03 como nós do tipo worker 
echo ""
echo "Setting vgr02 as a worker node"
echo ""
docker-machine ssh vgr02 "docker swarm join --token $VBOXSWARMTOKEN $VBOX01IP:2377"
echo ""
echo "Setting vgr03 as a worker node"
echo ""
docker-machine ssh vgr03 "docker swarm join --token $VBOXSWARMTOKEN $VBOX01IP:2377"

# 6. Torne vgr01 a máquina ativa (para conectar o cliente do Docker avgr01)
# eval $(docker-machine env vgr01)
