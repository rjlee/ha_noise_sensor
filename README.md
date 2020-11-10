# ha_noise_sensor

A raspberry pi noise sensor for use with home assistant via [ffmpeg_noise](https://www.home-assistant.io/integrations/ffmpeg_noise/).

## How does it work ?

The noise sensor uses a [Raspberry Pi Zero WH](https://thepihut.com/products/raspberry-pi-zero-wh-with-pre-soldered-header) and a [Respeaker 2-Mic Hat](https://wiki.seeedstudio.com/ReSpeaker_2_Mics_Pi_HAT/) as the hardware, with [ffmpeg](https://ffmpeg.org/) and [rtsp-simple-server](https://github.com/aler9/rtsp-simple-server) streaming audio to the [ffmpeg_noise](https://www.home-assistant.io/integrations/ffmpeg_noise/) home assistant integration.

The `install.sh` script configures a *fresh* Raspberry Pi with a [Raspberry Pi OS Lite](https://www.raspberrypi.org/downloads/raspberry-pi-os/) to automatically start streaming a rtsp audio stream to home assistant on boot.

*Caveat:* You don't need to use a Respeaker Hat, however noiseless audio capture on the raspberry pi seems to be patchy at best using a USB microphone.

## What does it look like ?

<img src="/images/bare.jpg" width="400">
<img src="/images/case.jpg" width="400">

## Install

Setup a raspberry pi with a USB microphone or appropriate hat (e.g. the respeaker 2 mic) and ensure it has a static IP allocated (required for home assistant configuration).

## Install Config

Copy the install script onto the Pi and then review the configuration options:

```
INSTALL_DIR=/root/ffmpeg_noise
MICROPHONE_DEVICE=hw:1,0
RTSP_VERSION=0.12.0
RTSP_ARCH="linux_arm6"
```

* `INSTALL_DIR` = The directory that ha_noise_sensor will be installed into
* `MICROPHONE_DEVICE` = The alsa address of your USB microphone (see http://www.voxforge.org/home/docs/faq/faq/linux-how-to-determine-your-audio-cards-or-usb-mics-maximum-sampling-rate for details)
* `RTSP_VERSION` = The RTSP server version to install from https://github.com/aler9/rtsp-simple-server
* `RTSP_ARCH` = The CPU architecture version to install from https://github.com/aler9/rtsp-simple-server.  Use arm7 for Pi 3/4

Once configuration options have been set, execute:

`chmod u+x ./install.sh && ./install.sh`

Then reboot.

The sensor startup has a delay of 20 seconds before starting the audio stream.

## Home Assistant Configuration

In 'configuration.yaml' add:

```
binary_sensor:
  - platform: ffmpeg_noise
    name: "Noise sensor"
    input: rtsp://192.168.8.10:8554/live
    initial_state: true
    duration: 1
    reset: 5
    peak: -27
```

Replacing `192.168.8.10` with the static IP address of your Pi.

Details on the `peak` range value and other options for the sensor can be found at [ffmpeg_noise](https://www.home-assistant.io/integrations/ffmpeg_noise/).

## It's not working, help !

Test the stream with [VLC](https://www.videolan.org/vlc/index.html) using this address `rtsp://$YOURIP:8554/live`

Look at `/root/ffmpeg_noise/stream.sh`.  It executes two processes:

* `rtsp-simple-server` - this needs to be running before the ffmpeg stream
* `arecord ...| ffmmpeg ...` - this streams to rtsp-simple-server

You can try these commands on the command line to identify any issues.

## References

* https://www.home-assistant.io/blog/2017/02/03/babyphone/
