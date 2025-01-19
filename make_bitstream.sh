#!/usr/bin/env bash
#
# WILL ONLY WORK ON VLAD'S COMPUTER, ONLY USE IF YOU ARE DEVELOPING FPGA IMAGES
# - ADJUST PATHS TO SUIT YOUR LOCAL SETUP
#
# Helper script to copy RP-122 bit file from marcos_fpga folder and rename
# locally, then generate bin file
#
# WARNING: doesn't produce updated DTBO files! Only for use with the
# Vivado GUI workflow, which only generates a bit file.
#
# Need to have bootgen in the PATH
# Setup on my PC:
# . /opt/Xilinx/Vivado/2019.2/settings64.sh
# export PATH=/opt/Xilinx/Scout/2019.1/bin:$PATH
#

echo "all:{ marcos_fpga_rp-122.bit}" > marcos_fpga.bif
# mv ~/Documents/mri/marcos_fpga/hdl/tmp/marcos_fpga.runs/impl_1/system_wrapper.bit ./marcos_fpga_rp-122.bit
mv ~/Documents/mri/marcos_fpga/hdl/tmp/marcos_fpga.bit ./marcos_fpga_rp-122.bit
bootgen -image marcos_fpga.bif -arch zynq -process_bitstream bin -w
rm marcos_fpga.bif
