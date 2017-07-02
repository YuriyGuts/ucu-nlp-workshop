#!/usr/bin/env bash

BUILD_DIR=`pwd`

# Install system packages.
add-apt-repository -y ppa:git-core/ppa
apt update
apt install -y --no-install-recommends curl wget nano unzip cmake mc tree htop
apt install -y software-properties-common python3 python3-dev python3-setuptools python3-pip git

# Configure SSH. Very insecure for a production setup but OK for an ephemeral learning environment.
echo "ListenAddress 0.0.0.0"         >> /etc/ssh/sshd_config
echo "PermitRootLogin yes"           >> /etc/ssh/sshd_config
echo "PasswordAuthentication yes"    >> /etc/ssh/sshd_config
echo "PermitEmptyPasswords yes"      >> /etc/ssh/sshd_config
echo 'root:ucuml' | chpasswd
rm -f /etc/service/sshd/down

# Install Python packages.
pip3 install --upgrade pip
pip3 install --upgrade numpy scipy statsmodels pandas matplotlib seaborn scikit-learn plotly nltk gensim
pip3 install --upgrade ipython jupyter
pip3 install --upgrade tqdm pydot watermark pygoose
# TODO: REQUIREMENTS.TXT

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
python3 setup.py install

# Install LightGBM.
git clone --recursive https://github.com/Microsoft/LightGBM /src/LightGBM
cd /src/LightGBM
mkdir build
cd build
cmake ..
make -j $(nproc)
cd ../python-package
python3 setup.py install

# TensorFlow and Keras.
pip3 install tensorflow keras

# Spacy.
pip3 install --upgrade spacy
python3 -m spacy download en

# Clean up.
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
cd ${BUILD_DIR}
