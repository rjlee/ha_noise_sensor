#!/bin/bash

INSTALL_DIR=/root/ffmpeg_noise
MICROPHONE_DEVICE=hw:1,0
RTSP_VERSION=0.12.0
RTSP_ARCH="linux_arm7"

# Install package updates & ffmpeg
apt-get update
apt-get dist-upgrade -y
apt-get install ffmpeg

mkdir -p $INSTALL_DIR
cd $INSTALL_DIR
RTSP_RELEASE="rtsp-simple-server_v${RTSP_VERSION}_${RTSP_ARCH}"
wget https://github.com/aler9/rtsp-simple-server/releases/download/v$RTSP_VERSION/$RTSP_RELEASE.tar.gz
tar xvfz $RTSP_RELEASE.tar.gz && rm $RTSP_RELEASE.tar.gz
chmod u+x rtsp-simple-server

# Create ffmpeg streaming bash script
(
cat <<STREAMFILE
#!/bin/bash

$INSTALL_DIR/rtsp-simple-server >/dev/null 2>&1 &
sleep 20
ffmpeg -re -ac 1 -f alsa -i $MICROPHONE_DEVICE -f rtsp -rtsp_transport tcp rtsp://localhost:8554/live </dev/null > /dev/null 2>&1 &
STREAMFILE
) > ./stream.sh
chmod u+x ./stream.sh

# Note this replaces the existing /etc/rc.local
# Start rtsp server & ffmpeg stream
(
cat <<INITFILE
#!/bin/bash

$INSTALL_DIR/stream.sh
exit 0
INITFILE
) > /etc/rc.local
chmod u+x /etc/rc.local

# Enable auto updates
(
cat <<UPDATEFILE
#!/bin/bash
apt-get update && apt-get dist-upgrade -y && apt autoremove -y
exit 0
UPDATEFILE
) > /etc/cron.daily/auto-update
chmod u+x /etc/cron.daily/auto-update
