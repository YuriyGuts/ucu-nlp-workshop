#!/usr/bin/env bash

CONDA_HOME=/opt/miniconda


# Install system packages.
add-apt-repository -y ppa:git-core/ppa
apt update
apt install -y --no-install-recommends curl wget nano git zip bzip2 tree htop mc ncdu graphviz
apt install -y --no-install-recommends software-properties-common gcc g++ make cmake

# Install Miniconda.
cd /tmp
wget -q https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
/bin/bash Miniconda3-latest-Linux-x86_64.sh -f -b -p $CONDA_HOME
rm Miniconda3-latest-Linux-x86_64.sh

conda config --system --add channels anaconda
conda config --system --add channels r
conda config --system --add channels conda-forge
conda config --system --set auto_update_conda false
conda config --system --set channel_priority false
conda config --system --set show_channel_urls true

# Install conda packages.
conda install --yes libgcc
conda install --yes --file /opt/docker/requirements-r.txt
conda install --yes --file /opt/docker/requirements-python.txt
conda clean -tipsy


# Configure SSH. Very insecure for a production setup but OK for an ephemeral learning environment.
echo "ListenAddress 0.0.0.0"         >> /etc/ssh/sshd_config
echo "PermitRootLogin yes"           >> /etc/ssh/sshd_config
echo "PasswordAuthentication yes"    >> /etc/ssh/sshd_config
echo "PermitEmptyPasswords yes"      >> /etc/ssh/sshd_config
echo 'root:ucuml' | chpasswd
rm -f /etc/service/sshd/down


## Install other Python packages.
pip install pygoose pydot3 pyemd pylev python-Levenshtein jellyfish


# Create Jupyter config.
jupyter notebook --allow-root --generate-config -y
echo "c.NotebookApp.ip = '*'"        >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.port = 8888"     >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.password = ''"   >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.token = ''"      >> ~/.jupyter/jupyter_notebook_config.py
jupyter nbextension enable --py --sys-prefix widgetsnbextension


# Install XGBoost.
git clone --recursive https://github.com/dmlc/xgboost /src/xgboost
cd /src/xgboost
make -j $(nproc)
cd python-package
python setup.py install


# Install LightGBM.
git clone --recursive https://github.com/Microsoft/LightGBM /src/LightGBM
cd /src/LightGBM
mkdir build
cd build
cmake ..
make -j $(nproc)
cd ../python-package
python setup.py install


# Install fastText.
git clone https://github.com/facebookresearch/fastText /src/fastText
cd /src/fastText
make
cp -f fasttext /usr/local/bin/fasttext


# Download models and corpora.
python -m spacy download en
python -m nltk.downloader stopwords brown wordnet averaged_perceptron_tagger


# Clean up.
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /src

# Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start.
sed -i "s/^exit 101$/exit 0/" /usr/sbin/policy-rc.d

# Avoid libreadline errors in R kernels.
ln -sf /lib/x86_64-linux-gnu/libreadline.so.6 $CONDA_HOME/lib/libreadline.so.6
