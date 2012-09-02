#!/bin/bash
# Outer loop for build and image
while :
do
 # Inner loop for git pull
 while :
 do
 GIT=$(git pull)
 echo $GIT
 if [ "$GIT" = 'Already up-to-date.' ]
 then
 echo 'Waiting half an hour for another pull at Git'
 sleep 1800
 else
 echo 'Kicking off the build and post build processes'
 break
 fi
 done
 # Delete old build
 rm -rf build.OpenELEC-RPi.arm-devel
 # Make release
 PROJECT=RPi ARCH=arm make release
 # Run packaging script
 ./lendit.sh
# Loop back to start of script
done
