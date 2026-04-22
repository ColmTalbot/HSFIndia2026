#!/bin/bash

conda create -y -n bilby python=3.12 bilby_pipe ipykernel lalframe
conda activate bilby
python -m ipykernel install --user --name bilby --display-name "Bilby"

cd single-event-inference/data
if [ -f /home/colm.talbot/HSFIndia2026/single-event-inference/data/L-L1_GWOSC_16KHZ_R1-1240213455-4096.gwf ]; then
   cp /home/colm.talbot/HSFIndia2026/single-event-inference/data/L-L1_GWOSC_16KHZ_R1-1240213455-4096.gwf ./
else
   wget https://gwosc.org/eventapi/html/GWTC-2.1-confident/GW190425/v3/L-L1_GWOSC_16KHZ_R1-1240213455-4096.gwf
fi
if [ -f /home/colm.talbot/HSFIndia2026/single-event-inference/data/V-V1_GWOSC_16KHZ_R1-1240213455-4096.gwf ]; then
   cp /home/colm.talbot/HSFIndia2026/single-event-inference/data/V-V1_GWOSC_16KHZ_R1-1240213455-4096.gwf ./
else
   wget https://gwosc.org/eventapi/html/GWTC-2.1-confident/GW190425/v3/V-V1_GWOSC_16KHZ_R1-1240213455-4096.gwf
fi
cd -
