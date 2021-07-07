#!/usr/bin/env bash
#
# Quick helper script to generate bin files from bit files in this folder
#
# WARNING: doesn't produce updated DTBO files! Only for use with the
# Vivado GUI workflow, which only generates a bit file.
# 
# Need to have bootgen in the PATH
# Setup on my PC:
# . /opt/Xilinx/Vivado/2019.2/settings64.sh
# export PATH=/opt/Xilinx/Scout/2019.1/bin:$PATH
#

echo "all:{ ocra_mri_rp-122.bit}" > ocra_mri.bif
bootgen -image ocra_mri.bif -arch zynq -process_bitstream bin -w
echo "all:{ ocra_mri_rp-125.bit}" > ocra_mri.bif
bootgen -image ocra_mri.bif -arch zynq -process_bitstream bin -w
rm ocra_mri.bif
