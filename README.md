# ucu-nlp-workshop

Supplementary resources for the [NLP Summer Workshop](http://cs.ucu.edu.ua/en/course/natural-language-processing-summer-workshop-2017/) I taught at UCU.


## Course Materials

Additional course notes and examples will be published in the `notebooks` directory as the course progresses.


## Development Environment

Instead of setting up your own environment from scratch, you can use the pre-built [Docker](https://www.docker.com/) image for most of the course samples and assignments.

The environment contains a Python 3.6 (Miniconda) installation with the most popular machine learning
and language processing libraries (scikit-learn, nltk, spaCy, fastText, gensim, TensorFlow, Keras etc.).

Run the following commands to get started:

**0. Install Docker and Python on the host.**

Python is used only to start the environment, and both Python 2 and Python 3 will work.

**1. Clone this repo.**

```
$ git clone https://github.com/YuriyGuts/ucu-nlp-workshop
```

**2. Pull the Docker image.**

```
$ docker pull yuriyguts/ucu-nlp-workshop
```

**3. Run the environment.**

The environment will mount your local data folder inside the container filesystem.
Assuming you'd like to use the `notebooks` directory from this repo, run:

```
$ cd ucu-nlp-workshop
$ python startenv.py notebooks
```

To mount some other code/data directory instead of `./notebooks`:

```
$ python startenv.py /path/on/my/local/machine
```

For help and additional options, run:

```
$ python startenv.py -h
```

**4. Open Jupyter.**

Navigate to [http://localhost:8888](http://localhost:8888) in your browser and start working there.

To test the environment, run the `test-env-python.ipynb` notebook in Jupyter.


**Extras: Terminal access.**

If needed, you can access the container shell in two ways:

1. Run a new terminal in the browser from the Jupyter home page (New > Terminal).
2. Connect via SSH (the default root password is `ucuml`):

```
$ ssh -o UserKnownHostsFile=/dev/null -p 2222 root@localhost
```
