#!/bin/bash

if [ -d /sys/kernel/config/device-tree/overlays/full ]; then
    rmdir /sys/kernel/config/device-tree/overlays/full
fi

echo 0 > /sys/class/fpga_manager/fpga0/flags
cp ~/bitstreams/ocra_mri_2020_03_05_v01.bit.bin ~/bitstreams/ocra_mri.dtbo /lib/firmware/

mkdir /sys/kernel/config/device-tree/overlays/full
echo -n "ocra_mri.dtbo" > /sys/kernel/config/device-tree/overlays/full/path
