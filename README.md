# Video Looper for Raspbian
Automatically play and loop fullscreen videos on a Raspberry Pi 2 or 3.

This system uses a basic bash script to play videos with [omxplayer](http://elinux.org/Omxplayer), it simply checks if omxplayer isn't running and then starts it again. This simple method seems to work flawlessly for weeks on end without freezing or glitches. The only caveat of this method is that there are approximately 2-3 seconds of black between each video. If you are looking to do something with gapless looping on Raspberry Pi, try [Slooper](https://github.com/mokafolio/Slooper) by [Matthias Dörfelt](http://www.mokafolio.de/), though currently it needs a few updates to work without a remote (as of May 15, 2016).

There is a [videolooper](https://github.com/adafruit/pi_video_looper) written in python that uses omxplayer by [Adafruit](http://www.adafruit.com), but unfortunately on testing looping videos for more than a day it froze (as of May 15, 2016).

The script will look for videos either in:
* the `video` directory in the home directory of the pi user
* a usb stick plugged in before startup (this will not be remounted if you pull it out and plug it back in)

## Installation
Start with a [raspbian img (lite)](https://www.raspberrypi.org/downloads/raspbian/), install it on the pi, and follow the steps below to install the videolooper.

### Modify the "config.txt"
Insert or update the following parameters in the `/boot/config.txt` 
```
disable_overscan=1
hdmi_force_hotplug=1
disable_splash=1
gpu_mem=128
```
### Make some changes via `sudo raspi-config`
* Select option: "3 Boot Options"
* Select option: "B1 Desktop / CLI"
* Select option: "B2 Console Autologin"
* Select option: "3 Boot Options"
* Select option: "B2 Wait for Network at Boot"
* Select option: "No"
* Select option: "1 Expand Filesystem"

> Also look at the "Localisation Options"

### Disable RPi screen blanking in console
If your screen goes black during command line after 30 minutes or so, you have screen blanking enabled most likely. If you want to turn it off:
Edit the file `/etc/kbd/config` Change these lines:
```
BLANK_TIME=0
BLANK_DPMS=off
POWERDOWN_TIME=0
```
### Install needed packages (omxplayer, git)
```
sudo apt update
sudo apt -y install omxplayer git-core
```

### Setup auto mounting of usb stick
```
sudo mkdir -p /mnt/usbdisk
```
Choose one of the following lines. The diffrence is, that the first mounts the USB Drive Read Only. This will prevent the Drive from damage if it is removed wihout unmounting. The second mounts the USB Drive writable.
```
sudo echo "/dev/sda1  /mnt/usbdisk  auto  ro,nofail  0 0" | sudo tee -a /etc/fstab #read only
sudo echo "/dev/sda1  /mnt/usbdisk  auto  user,umask=000,utf8,nofail  0 0" | sudo tee -a /etc/fstab #writable
```

### Create folder for videos in home directory
`mkdir /home/pi/video`

### Download the script
```
cd /home/pi
git clone https://github.com/herbetom/videolooper-raspbian.git
chmod uga+rwx videolooper-raspbian/startvideo.sh videolooper-raspbian/startvideo_random.sh
```

### Add startvideo_random.sh to .bashrc so it auto starts on login
`echo \"/home/pi/startvideo_random.sh" | tee -a /home/pi/.bashrc`


## Errorhandling
If you get the following Error 'COMXAudio::Decode timeout' add the following to the file `/boot/config.txt`
`gpu_mem=128`.
This will give the GPU more memory.
