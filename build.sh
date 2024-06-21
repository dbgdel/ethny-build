#!/bin/bash
# source ./.env

# echo "Building $VERSION"

# # Changing to build directory
# cd build

# # Login to scontain registry using environment variables (The are set in Gitlab now)
# docker login registry.scontain.com:5050 -u ${ce.c.marius@gmail.com} -p ${SCONTAIN_PASS}

# # Stop and remove any existing containers, images, and volumes
# docker compose down --rmi all --volumes 

# # Build the etny-nodenithy image
# docker build -t etny-nodenithy:latest .

# # Build the etny-las image
# docker build -t etny-las -f las/Dockerfile .


#!/bin/bash
source .env

echo "Building $VERSION"

cd build

docker login registry.scontain.com:5050 -u ${SCONTAIN_LOGIN} -p ${SCONTAIN_PASS}

docker stop $(docker ps -q)
docker rm $(docker ps -q) -f
docker rmi $(docker images -q) -f
docker system prune -f

docker pull registry:2
docker run -d --restart=always -p 5001:5001 --name registry registry:2
docker build -t etny-nodenithy:latest .
docker tag etny-nodenithy localhost:5000/etny-nodenithy
docker push localhost:5000/etny-nodenithy

cd las
docker build -t etny-las .
# docker tag etny-las localhost:5000/etny-las
# docker push localhost:5000/etny-las

cd ..
docker cp ../scripts/build-ipfs-upload.sh registry:/
docker cp ../scripts/ipfs-daemon.sh registry:/

HASH=`docker exec -it registry /build-ipfs-upload.sh | grep "HASH is" | awk '{print $3}' | tr -d '\r'`

echo Following hash was pinned: ${HASH}

# git pull
# cd ../..
# touch hashes/${HASH}
# git add hashes/*

# git commit -a -m "Added hash ${HASH}"
# git push
