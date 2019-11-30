#!/bin/sh
if [ -d $HOME/src ]; then
    /opt/conda/bin/pip install --user --editable $HOME/src
fi
cd $HOME
exec /usr/bin/tini -- "$@"
