# LogitechMediaServerDocker
Files to create a Logitech Media Server Docker Image

## Build image locally

```shell
docker build -t logitechmediaserver .
```

## Run image locally

```shell
docker run \
           -p 9000:9000 \
           -p 9090:9090 \
           -p 3483:3483 \
           -p 3483:3483/udp \
           -v /home/logitechmediaserver/server:/srv/squeezebox \
           -v /home/logitechmediaserver/music:/srv/music \
           -v /home/logitechmediaserver/playlists:/srv/playlists \
           -u `id -u $USER` \
           logitechmediaserver
```