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
ssh root@$1 "date -s \"$(date)\""

echo "Copying FPGA bitstream..."
scp ocra_mri.bit.bin ocra_mri.dtbo root@$1:/lib/firmware/

echo "Writing bitstream to FPGA (you should see a blue light appear) ..."
# borrowed trick from https://stackoverflow.com/questions/305035/how-to-use-ssh-to-run-a-shell-script-on-a-remote-machine
ssh root@$1 <<EOF
#!/bin/bash

if [ -d /sys/kernel/config/device-tree/overlays/full ]; then
    rmdir /sys/kernel/config/device-tree/overlays/full
fi

echo 0 > /sys/class/fpga_manager/fpga0/flags

mkdir /sys/kernel/config/device-tree/overlays/full
echo -n "ocra_mri.dtbo" > /sys/kernel/config/device-tree/overlays/full/path
EOF

echo "Copying MaRCoS server..."
# borrowed trick of avoiding .git folder from https://stackoverflow.com/questions/11557114/cp-r-without-hidden-files
git clone --depth=1 https://github.com/vnegnev/marcos_server.git /tmp/marcos_server
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
rm -rf /tmp/marcos_server
EOF

echo "You can run the MaRCoS server by entering the following command:"
echo "ssh root@$1 \"~/marcos_server\""
