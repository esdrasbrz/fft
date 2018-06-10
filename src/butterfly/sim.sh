#!/bin/bash

ghdl --clean
ghdl -a butterfly.vhd
ghdl -a butterfly_tb.vhd
ghdl -e butterfly_tb
ghdl -r butterfly_tb
