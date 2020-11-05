# ha_noise_sensor

A raspberry pi noise sensor for use with home assistant

## Install

Setup a raspberry pi with a USB microphone or appropriate hat (e.g. the respeaker 2 mic) and ensure it has a static IP allocated (required for home assistant configuration).

## Install Config

Copy the install script onto the Pi and then review the configuration options:

```
INSTALL_DIR=/root/ffmpeg_noise
MICROPHONE_DEVICE=hw:1,0
RTSP_VERSION=0.12.0
RTSP_ARCH="linux_arm7"
```

INSTALL_DIR = The directory that ha_noise_sensor will be installed into
MICROPHONE_DEVICE = The alsa address of your USB microphone (see http://www.voxforge.org/home/docs/faq/faq/linux-how-to-determine-your-audio-cards-or-usb-mics-maximum-sampling-rate for details)
RTSP_VERSION = The RTSP server version to install from https://github.com/aler9/rtsp-simple-server
RTSP_ARCH = The CPU architecture version to install from https://github.com/aler9/rtsp-simple-server

Once configuration options have been set, execute:

`chmod u+x ./install.sh && ./install.sh`

## Home Assistant Configuration

In 'configuration.yaml' add:

```
binary_sensor:
  - platform: ffmpeg_noise
    name: "Noise sensor"
    input: rtsp://192.168.8.10:8554/live
    initial_state: true
    duration: 3
    reset: 15
    peak: -34
```

Replacing `192.168.8.10` with the static IP address of your Pi.
