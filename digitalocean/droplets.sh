#!/bin/bash
# set -x

# create servers in DigitalOcean
# https://docs.docker.com/machine/drivers/digital-ocean/

#
# DO_TOKEN should be replaced with your personal token from digitalocean.com (read/write)
DO_TOKEN=8cd1d33bcc9a8c734f6d7ff7f933825ec62a946196a6d88635c29503b8d7d91d

#
# DO_SIZE defines droplet size
# Choose a size using DigitalOcean CLI command: doctl compute size list
# https://www.digitalocean.com/community/tutorials/how-to-use-doctl-the-official-digitalocean-command-line-client
# If you do not define it, you will get the default size
DO_SIZE=s-1vcpu-1gb

for server in {1..3}; do
  docker-machine create \
  --driver=digitalocean \
  --digitalocean-access-token="${DO_TOKEN}" \
  --digitalocean-size="${DO_SIZE}" \
  --digitalocean-tags=rexray \
  --digitalocean-private-networking=true \
  do${server} &
done

