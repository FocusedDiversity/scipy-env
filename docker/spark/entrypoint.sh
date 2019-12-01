#!/bin/sh
cat > /opt/polynote/config.yml <<-EOF
listen:
  host: 0.0.0.0
  port: ${PORT}

storage:
 dir: ${HOME}/notebooks
 cache: /tmp
EOF

echo "---- starting polynote, config: -----\n"
cat /opt/polynote/config.yml
echo "---- end config -----"

if [ -d $HOME/src ]; then
    /opt/conda/bin/pip install --user --editable $HOME/src
fi
 
exec /usr/bin/tini -- "$@"
