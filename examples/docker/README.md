# Example Standard Docker Environment

## Usage

To run the container, simply run `make`.

Once the container has started, you should see some output:

```
[I 21:14:40.634 LabApp] The Jupyter Notebook is running at:
[I 21:14:40.634 LabApp] http://ed2b71bfe63f:51000/?token=b4a4ae3ffb8db5a8ad85bb331e1d0dc38ba7c73483bae3c0
[I 21:14:40.634 LabApp]  or http://127.0.0.1:51000/?token=b4a4ae3ffb8db5a8ad85bb331e1d0dc38ba7c73483bae3c0
```

On a local PC, simply browser to the link. On a secured remote system, set up an ssh tunnel then browser. Across
the local network.

### Validate the Environment

Once you are connceted to jupyter lab, browse to the notebooks holder and the `00 Environment` notebook. Run the cells. The
notebook will validate that your GPU exists, that ir works with tensorflow and that it works with opencv. Finally, it ensures
necessary folders exist and have the correct access.

As you work on your project, you should extend this notebook to ensure that other dependencies are properly installed and
any folders that might need to be created, or files that need to be downloaded, are easily reproducible.

### Run the tests

`make test`

## Requirements

- Docker 19.03+ 

## File Layout

### data

Immutable source data. Mounted read-only into the container. Should be populated with customer
provided data via a script, if necessary.

### scratch

Ephemeral working data. Should never be checked in, and only shared under duress.

### notebooks

Python notebooks. Mounted read-write into the container. Should be checked in (without cell content). Use nbstripout.

### src

Python src. For significant functions, prefer creating them in a package in the src folder and 
importing into the notebooks as needed. As long as there is a `setup.py` file in `src/` the
container will always ensure it is installed into the python environment as an editable
package, so you will be able to make changes in real time via your local editor or
via jupyterlab. 

#### auto reload

For notebooks dependent on rapid changes to the python module, you may want to add the following incantion
to ensure all python modules are auto-reloaded when cells are run.

```
%load_ext autoreload
%autoreload 2
```

#### tests

By default, the Makefile runs tests using pytest. The tests are discovered inside `src/tests` folder


## Using with AWS

- Create an instance, either g4dn or p3 using the AWS Deep Learning AMI on Ubuntu 18.04
- Create a host entry for convenience in ~/.ssh/config

```
Host dev1
	Hostname XXXXXX.compute-1.amazonaws.com
	User ubuntu
	IdentityFile ~/.ssh/YYYYY.pem
    	LocalForward 127.0.0.1:51000 127.0.0.1:51000
```

- Log in and clone this repo
- `docker run`
- Open the link provided by jupyter lab
