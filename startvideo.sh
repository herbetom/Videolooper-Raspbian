#!/bin/bash
# Bash script by Tim Schwartz, http://www.timschwartz.org/raspberry-pi-video-looper/ 2013
# Comments, clean up, improvements by Derek DeMoss, for Dark Horse Comics, Inc. 2015
# Added USB support, full path, support files with spaces in names, support more file formats - Tim Schwartz, 2016

declare -A VIDS # make variable VIDS an Array

LOCAL_FILES=~/video/ # A variable of this folder
USB_FILES=/mnt/usbdisk/ # Variable for usb mount point
CURRENT=0 # Number of videos in the folder
SERVICE='omxplayer' # The program to play the videos
PLAYING=0 # Video that is currently playing
FILE_FORMATS='.mov|.mp4|.mpg'

getvids () # Since I want this to run in a loop, it should be a function
{
unset VIDS # Empty the VIDS array
CURRENT=0 # Reinitializes the video count
IFS=$'\n' # Dont split up by spaces, only new lines when setting up the for loop
for f in `ls $LOCAL_FILES | grep -E $FILE_FORMATS` # Step through the local files
do
	VIDS[$CURRENT]=$LOCAL_FILES$f # add the filename found above to the VIDS array
	# echo ${VIDS[$CURRENT]} # Print the array element we just added
	let CURRENT+=1 # increment the video count
done
if [ -d "$USB_FILES" ]; then
  for f in `ls $USB_FILES | grep -E $FILE_FORMATS` # Step through the usb files
	do
		VIDS[$CURRENT]=$USB_FILES$f # add the filename found above to the VIDS array
		#echo ${VIDS[$CURRENT]} # Print the array element we just added
		let CURRENT+=1 # increment the video count
	done
fi
}

while true; do
if ps ax | grep -v grep | grep $SERVICE > /dev/null # Search for service, print to null
then
	echo 'running'
else
	getvids # Get a list of the current videos in the folder
	if [ $CURRENT -gt 0 ] #only play videos if there are more than one video
	then
		let PLAYING+=1
		if [ $PLAYING -ge $CURRENT ] # if PLAYING is greater than or equal to CURRENT
		then
			PLAYING=0 # Reset to 0 so we play the "first" video
		fi

	 	#echo ${VIDS[$PLAYING]}
	 	if [ -f ${VIDS[$PLAYING]} ]; then
			/usr/bin/omxplayer -r -o both ${VIDS[$PLAYING]} # Play video
		fi
		# echo "Array size= $CURRENT" # error checking code
	else
		echo "Insert USB with videos and restart or add videos to /home/pi/video and run ./startvideo.sh"
		exit
	fi
fi
done
