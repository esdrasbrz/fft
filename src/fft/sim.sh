#!/bin/bash

ghdl --clean
ghdl -a ../butterfly/butterfly.vhd
ghdl -a fft.vhd

