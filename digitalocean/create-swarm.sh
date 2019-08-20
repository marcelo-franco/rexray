#!/bin/bash

# 1. Obtenha o endereco IP da maquina do1
echo ""
echo "Getting IP of do1..."
echo ""
DO1IP=$(docker-machine ip do1)

# 2. Inicialize o modo swarm do Docker na maquina do1 (manager)
echo ""
echo "Initializing Docker swarm mode on do1"
echo ""
docker-machine ssh do1 "docker swarm init --advertise-addr $DO1IP --listen-addr $DO1IP"

# 3. Obtenha o token do swarm que permite adicionar nodes do tipo worker
echo ""
echo "Getting token to add worker nodes..."
echo ""
SWARMTOKEN=$(docker-machine ssh do1 "docker swarm join-token -q worker")

# 4. Adicione as maquinas do2 e do3 como nodes do tipo worker 
echo ""
echo "Setting do2 as a worker node"
echo ""
docker-machine ssh do2 "docker swarm join --token $SWARMTOKEN $DO1IP:2377"
echo ""
echo "Setting do3 as a worker node"
echo ""
docker-machine ssh do3 "docker swarm join --token $SWARMTOKEN $DO1IP:2377"

# 5. Torne do1 a maquina ativa (para conectar o cliente do Docker ao node do1)
# eval $(docker-machine env do1)
