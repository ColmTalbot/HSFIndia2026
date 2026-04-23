#!/bin/bash

conda create -y -n bilby python=3.12 bilby_pipe ipykernel lalframe
python -m ipykernel install --user --name bilby --display-name "Bilby"

cd single-event-inference/data
wget https://gwosc.org/eventapi/html/GWTC-2.1-confident/GW190425/v3/L-L1_GWOSC_16KHZ_R1-1240213455-4096.gwf
wget https://gwosc.org/eventapi/html/GWTC-2.1-confident/GW190425/v3/V-V1_GWOSC_16KHZ_R1-1240213455-4096.gwf
cd -
