#!/bin/bash
if [[ -d $HOME/src && -f $HOME/src/setup.py ]]; then
    /opt/conda/bin/pip install --user --editable $HOME/src
fi
cd $HOME
exec /usr/bin/tini -- "$@"
