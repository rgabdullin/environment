# ruslixag's development environment
* `docker build -t rgabdullin/environment:v1.1 .`
* `docker run --restart always --shm-size=512m -it -d -p 6006:6006 -p 8888:8888 -p 8787:8787 -p 8786:8786 -v /workspace:/workspace --name jupyter-notebook rgabdullin/environment:v1.1`
