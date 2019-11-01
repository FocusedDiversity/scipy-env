# Standard SciPy Environment

# Local use (without docker)

## Get Anaconda

Download from https://www.anaconda.com/distribution/

Generally, we should be tracking the latest version but the docker container
is pinned manually so if you don't want to take the time to push an update into the 
container, make sure to download the same version of Anaconda that gets downloaded
in docker/Dockerfile.

Docker Environment

# How to use (short version)

From the "docker" folder:
`make`

If all is well, you'll get output like this:
```
[I 22:13:16.284 NotebookApp] The Jupyter Notebook is running at:
[I 22:13:16.284 NotebookApp] http://3535478bbb15:51000/?token=dce7406e1d25feb11379eed71d4798647358a2515f81118e
[I 22:13:16.284 NotebookApp]  or http://127.0.0.1:51000/?token=dce7406e1d25feb11379eed71d4798647358a2515f81118e
[I 22:13:16.284 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
```

Set up port forwarding, forwarding the port from your local machine to this one, such as 51000 -> 127.0.0.1:51000

Browse to the link. Jupyter should be running.

# How to add python dependencies

Edit environment.yml. Restart the container.

If that doesn't work, install anaconda locally (as described below), then install
your packages using `pip` and `conda` as needed, then export the environment with
`conda env export > environment.yml` and check in the updated environment.yml file.

# How to use this conda environment locally (without docker)

- Set up anaconda3 from https://www.anaconda.com/distribution/
- Activate your environment.
- Run `make update-env`
- Symlink the data folder from /home/synaptiq to ~/data -- `ln -s /home/synaptiq ~/data`

# What about `Bind for 127.0.0.1:51001 failed: port is already allocated.`?

You somehow left an orphan docker process running. Look for the orphaned process with `docker ps`, the output should look
something like this:

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                        NAMES
a11705a8d1c8        poc:latest          "/usr/bin/tini -- /b…"   6 minutes ago       Up 6 minutes        127.0.0.1:51001->51001/tcp   nifty_cerf
```

Then stop the process with `docker stop a11705a8d1c8` where `a11705a8d1c8` is the value in the CONTAINER_ID column.

# Where should I put my notebooks.

In the `notebooks` folder here in git.

# Where is my working data?

Under your home directory in a folder called `scratch`

# How do I check them in.

With git. If you have anaconda3 set up properly ( as above), you will have a program called `nbstripout` on
your path. Git will automatically use this to strip data from your local notebooks before checking them in. If
you do not have this program, checking in notebooks will fail.

# Why is this so complicated

- Because docker on linux requires matching unix permissions
- Because we need a usable and reproducible python development environment
