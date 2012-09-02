# Set env vars for release package name
TARBALL=$(ls -t ~/OpenELEC.tv/target | head -1)
BUILD=$(echo $TARBALL | sed 's/.tar.bz2//')
RELEASE=$(echo $BUILD | sed 's/.*-r/r/')
IMGFILE=~/OpenELEC.tv/releases/$RELEASE.img
# Copy release build to web server
sudo cp ~/OpenELEC.tv/target/$TARBALL /var/www
cp ~/OpenELEC.tv/target/$TARBALL /mnt/box/OpenELEC
# Unpack release
cd ~/OpenELEC.tv/releases
tar -xvf ~/OpenELEC.tv/target/$TARBALL
# Wipe virtual SD
sudo dd if=/dev/zero of=$IMGFILE bs=1M count=910
# Move into release working directory
cd ~/OpenELEC.tv/releases/$BUILD
#Run script to create SD card
sudo ../create_loop_sd /dev/loop0 $IMGFILE
#Get into right directory
cd ..
# Compress release file
zip ./$RELEASE.img.zip ./$RELEASE.img
# Remove image file
sudo rm ./$RELEASE.img
# Copy zipped image to web server
sudo cp ./$RELEASE.img.zip /var/www
cp ./$RELEASE.img.zip /mnt/box/OpenELEC
# Go back to OpenELEC directory
cd ~/OpenELEC.tv
# Send an email
python gmail.py "OpenELEC Build Complete - $RELEASE" $BUILD
