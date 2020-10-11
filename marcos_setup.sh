#!/bin/bash
# Vlad Negnevitsky, May 2020
# Rudimentary setup procedure for the STEMlab

if test "$#" -ne 1; then
    echo "Usage: ./marcos_setup.sh 192.168.1.163"
    echo "(the IP address is that of your STEMlab)"
    exit
fi

echo "Setting up MaRCoS on IP $1..."

echo "Setting date on the STEMlab based on the host date..."
ssh root@$1 "date -s \"$(LC_TIME=POSIX date)\""

./copy_bitstream.sh $1

echo "Killing any existing server instances..."
ssh root@$1 "killall marcos_server"

echo "Copying MaRCoS server..."
# borrowed trick of avoiding .git folder from https://stackoverflow.com/questions/11557114/cp-r-without-hidden-files
git clone --depth=1 -b rp-125 https://github.com/vnegnev/marcos_server.git /tmp/marcos_server
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
cp marcos_server ~/
# rm -rf /tmp/marcos_server
EOF

echo "You can run the MaRCoS server by entering the following command:"
echo "ssh root@$1 \"~/marcos_server\""
