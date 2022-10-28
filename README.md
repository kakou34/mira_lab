  ## Environment set up

  Start by creating a new conda environment

  ```bash
  conda update -y -n base -c defaults conda &&
  conda create -y -n mira anaconda &&
  conda activate mira &&
  conda install pytorch torchvision torchaudio cudatoolkit=10.2 -c pytorch
  ```

  Install requirements:

  ```bash
  pip install -r requirements.txt
  ```