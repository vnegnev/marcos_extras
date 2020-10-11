#!/bin/bash
# Vlad Negnevitsky, May 2020
# Rudimentary setup procedure for the STEMlab

if test "$#" -ne 1; then
    echo "Usage: ./copy_bitstream.sh 192.168.1.163"
    echo "(the IP address is that of your STEMlab)"
    exit
fi

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
