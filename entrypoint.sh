#!/bin/sh
/opt/conda/bin/pip install --user --editable /home/jupyter/src
exec /usr/bin/tini -- "$@"