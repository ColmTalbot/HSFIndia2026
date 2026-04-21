# HSFIndia2026
Materials for the HSF India-IUCAA joint workshop on gravitational-wave data analysis.

These were presented during a day on Bayesian inference for individual gravitational wave events and population-level analyses.

Some aspects of this were designed for use on the IUCAA Sarathi cluster and may refer to specific details about that system,
however, it should be possible to adapt all the examples to other setups.

## Setup

All of these setup stages can be performed automatically using the `setup.sh` script in this repository

```console
$ bash setup.sh
```

### Conda environment

To get started, you'll need to set up a conda environment and download some data
(pre-downloading the data is optional but advised on slow internet connections).

First, we will create the conda environment with the needed requirements and ensure that the environment is usable by `Jupyter`.

```console
$ conda create -y -n bilby python=3.12 bilby_pipe ipykernel lalframe
$ python -m ipykernel install --user --name bilby --display-name "Bilby"
```

### Download data

We will analyze the gravitational wave signal [GW190425](https://arxiv.org/abs/2001.01761),
for simplicity, I recommend directly downloading the relevant data (`.gwf`) files from [GWOSC](https://gwosc.org/).

```console
$ cd single-event-inference/data
$ wget https://gwosc.org/eventapi/html/GWTC-2.1-confident/GW190425/v3/L-L1_GWOSC_16KHZ_R1-1240213455-4096.gwf
$ wget https://gwosc.org/eventapi/html/GWTC-2.1-confident/GW190425/v3/V-V1_GWOSC_16KHZ_R1-1240213455-4096.gwf
$ cd -
```
