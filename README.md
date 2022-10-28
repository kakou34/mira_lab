# Medical Image Registration
## MAIA Master 2022


This repository contains all the code produced as part of the Medical Image Registration & Applications (MIRA) course part of the MAIA master.

Laboratories:


## Set up

Start by creating a new conda environment

```bash
conda update -y -n base -c defaults mira &&
conda create -y -n mira anaconda &&
conda activate mira
```

Install requirements:

```bash
pip install -r requirements.txt
```

### Download and prepare the database

```bash
mkdir data && cd data &&
gdown https://drive.google.com/uc?id=18zwp8YiYUW9j3XQjVqorAIoNxsPOCVn0 &&
unzip 'trainingSmall.zip' -d 'trainingSmall' && rm -rf 'trainingSmall.zip' &&
gdown https://drive.google.com/uc?id=1iTaLPPHg38EpbGEp_nU7aX3HG0-hdjoD &&
unzip 'training-set.zip' && rm -rf 'training-set.zip' &&
cd ../
```

### Add elastix excecutable to anaconda PATH

You'll need to modify the following paths to your local directories

```bash
cd elastix &&
gdown https://drive.google.com/uc?id=1RbDLW8UNlZXLTRlcsPAUgUyoyDADdQcH &&
mkdir 'elastix-5.0.0' && tar -xvf 'elastix-5.0.0-Linux.tar.bz2' -C 'elastix-5.0.0-Linux' &&
rm -rf 'elastix-5.0.0-Linux.tar.bz2' &&
cwd=$(pwd) &&
cd ../ &&
base="${cwd}/elastix-5.0.0-Linux" &&
anacondaenv="/home/jseia/anaconda3/envs/mira" &&
export PATH=bin/:$PATH &&
export LD_LIBRARY_PATH="${base}/lib":$LD_LIBRARY_PATH &&
sudo ln -s "${base}/bin/elastix" "${anacondaenv}/bin/elastix" &&
sudo ln -s "${base}/bin/transformix" "${anacondaenv}/bin/transformix" &&
sudo ln -s "${base}/lib/libANNlib-5.0.so" "${anacondaenv}/lib/libANNlib-5.0.so" &&
sudo ln -s "${base}/lib/libANNlib-5.0.so.1" "${anacondaenv}/lib/libANNlib-5.0.so.1" &&
source ~/.bashrc
```

Just for linux
``` bash
sudo rm /usr/bin/elastix &&
sudo rm /usr/bin/transformix &&
sudo ln -s "${base}/bin/elastix" /usr/bin/elastix &&
sudo ln -s "${base}/bin/transformix" /usr/bin/transformix &&
sudo ln -s "${base}/lib/libANNlib"-5.0.so /usr/lib/libANNlib-5.0.so &&
sudo ln -s "${base}/lib/libANNlib"-5.0.so.1 /usr/lib/libANNlib-5.0.so.1 &&
source ~/.bashrc
```


<!-- #### Suggestions for contributers

- numpy docstring format
- flake8 lintern
- useful VSCode extensions:
  - autoDocstring
  - Python Docstring Generator
  - GitLens -->
