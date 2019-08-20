#!/bin/bash
for i in 01 02 03; do
  echo ""
  echo "Installing REX-Ray on vgr${i}..."
  echo ""
  docker-machine ssh vgr"$i" "curl -sSL https://rexray.io/install | sh"
  echo ""
  echo "Creating config file for vgr${i}..."
  echo ""
  docker-machine ssh vgr"$i" "sudo tee /etc/rexray/config.yml << EOF
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
done

for i in 01 02 03; do
  echo ""
  echo "Inializing REX-Ray service on vgr${i}..."
  echo ""
  docker-machine ssh vgr"$i" "sudo systemctl start rexray </dev/null &>/dev/null &"
done
sleep 3s
for i in 01 02 03; do
  echo ""
  echo "Trying listing volumes on vgr${i}..."
  echo ""
  docker-machine ssh vgr"$i" "docker volume ls"
done
