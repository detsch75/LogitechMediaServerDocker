#!/usr/bin/env bash

if [[ $(getent passwd squeezeboxserver) = "" ]]; then
    useradd -M -s /usr/sbin/nologin -c "Squeezebox Server user" squeezeboxserver
fi

user_id=`id -u squeezeboxserver`

cat > /etc/systemd/system/docker.logitechmediaserver.service << EOF
[Unit]
Description=LogitechMediaServer Service
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
Restart=always
ExecStartPre=-/usr/bin/docker exec logitechmediaserver stop
ExecStartPre=-/usr/bin/docker rm -f logitechmediaserver
ExecStart=/usr/bin/docker run -d -u -u $user_id -p 9000:9000 -p 9090:9090 -p 3483:3483 -p 3483:3483/udp -v /home/logitechmediaserver/server:/srv/squeezebox -v /home/logitechmediaserver/music:/srv/music -v /home/logitechmediaserver/playlists:/srv/playlists --name logitechmediaserver logitechmediaserver
ExecStop=/usr/bin/docker exec logitechmediaserver stop
 
[Install]
WantedBy=default.target
EOF

systemctl daemon-reload
systemctl enable docker.logitechmediaserver.service