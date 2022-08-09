# ruslixag's development environment
* `docker-compose build`
* `docker-compose up -d`

## Run portainer
`docker run -d -p 9000:9000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data cr.portainer.io/portainer/portainer-ce:latest`

## Build
* `docker-compose build && docker-compose push`
* `docker build -t rgabdullin/environment-ubuntu-gpu:latest -f ubuntu-gpu/Dockerfile ubuntu-gpu && docker push rgabdullin/environment-ubuntu-gpu:latest`

## Deploy
* `docker stack deploy environment`

