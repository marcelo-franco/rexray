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

# 1. Crie as três máquinas virtuais
docker-machine create -d virtualbox vbox01 && docker-machine create -d virtualbox vbox02 && docker-machine create -d virtualbox vbox03

# 2. Obtenha o endereço IP da máquina vbox01
VBOX01IP=$(docker-machine ip vbox01)

# 3. Inicialize o modo swarm do Docker na máquina vbox01 (manager)
docker-machine ssh vbox01 "docker swarm init --advertise-addr $VBOX01IP --listen-addr $VBOX01IP"

# 4. Obtenha o token do swarm que permite adicionar nós do tipo worker
VBOXSWARMTOKEN=$(docker-machine ssh vbox01 "docker swarm join-token -q worker")

# 5. Adicione as máquinas vbox02 e vbox03 como nós do tipo worker 
docker-machine ssh vbox02 "docker swarm join --token $VBOXSWARMTOKEN $VBOX01IP:2377" && docker-machine ssh vbox03 "docker swarm join --token $VBOXSWARMTOKEN $VBOX01IP:2377"

# 6. Torne vbox01 a máquina ativa (para conectar o cliente do Docker a vbox01)
eval $(docker-machine env vbox01)
