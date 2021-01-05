#!/bin/bash
# Vlad Negnevitsky, May 2020
# Rudimentary setup procedure for the STEMlab

if [[ "$#" -ne 2 || ($2 != "rp-125" && $2 != "rp-122" ) ]]; then
    echo "Usage: ./marcos_setup.sh IP DEVICE"
    echo "IP: the IP address of your STEMlab/RP"
    echo "DEVICE: your STEMlab/RP hardware, either rp-122 or rp-125"
    echo "Example usage: "
    echo "   ./marcos_setup.sh 192.168.1.163 rp-122"
    echo "*Warning*: flocra bitstream currently only runs on rp-122 for now!"    
    exit
fi

echo "Setting up MaRCoS on IP $1..."

echo "Setting date on the STEMlab based on the host date..."
ssh root@$1 "date -s \"$(date -u)\""

./copy_bitstream.sh $1 $2

echo "Killing any existing server instances..."
ssh root@$1 "killall marcos_server"

echo "Copying MaRCoS server..."
# borrowed trick of avoiding .git folder from https://stackoverflow.com/questions/11557114/cp-r-without-hidden-files
git clone --depth=1 -b flocra https://github.com/vnegnev/marcos_server.git /tmp/marcos_server
ssh root@$1 "mkdir /tmp/marcos_server"
scp -r /tmp/marcos_server/* root@$1:/tmp/marcos_server
rm -rf /tmp/marcos_server # remove local copy

echo "Compiling MaRCoS server on the STEMlab..."
ssh root@$1 <<EOF
cd /tmp/marcos_server
mkdir build
cd build
cmake ../src
make -j2

# Either copy the server binary to ~/ or just make a symlink.
# Symlinks are best for development/debugging, since it forces
# recompilation of the latest version every time the RP is rebooted.
# Copying is best for experimental use, since it's persistent across
# reboots.
# 
# cd ~/
# ln -s /tmp/marcos_server/build/marcos_server
cp marcos_server ~/
# rm -rf /tmp/marcos_server
EOF

echo "You can run the MaRCoS server by entering the following command:"
echo "ssh root@$1 \"~/marcos_server\""
