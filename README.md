# ruslixag's development environment
* `docker-compose build`
* `docker-compose up -d`

## Run portainer
`docker run -d -p 9000:9000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data cr.portainer.io/portainer/portainer-ce:latest`

## Manual build of GPU image
* `docker build -t environment-gpu .`
* `docker run --restart always --gpus all --shm-size=512m -it -d -p 6006:6006 -p 8888:8888 -p 8787:8787 -p 8786:8786 -v /workspace:/workspace --name environment-gpu environment-gpu`
