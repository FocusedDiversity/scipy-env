#!/bin/sh
/opt/conda/bin/pip install --user --editable /home/jupyter/src
cd /home/jupyter
exec /usr/bin/tini -- "$@"