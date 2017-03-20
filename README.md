# R2docker fork from radare/radare2

This image is a fork from origin r2docker. It was created to shrink initial image and to limit number of layers.

Build docker image with:
```
$ docker build -t r2docker:1.3.0 .
```

Run the docker image:
```
$ docker images
$ export DOCKER_IMAGE_ID=$(docker images --format '{{.ID}}' -f 'label=r2docker')
$ docker run -ti r2docker:1.3.0
```

Once you quit the bash session get the container id with:
```
$ docker ps -a | grep bash
```

To get into that shell again just type:
```
$ docker start -ai <containedid>
```
If you willing to debug a program within Docker, you should run it in privileged mode:
```
$ docker run -it --cap-add=SYS_PTRACE --cap-drop=ALL radare/radare2
$ r2 -d /bin/true
```
