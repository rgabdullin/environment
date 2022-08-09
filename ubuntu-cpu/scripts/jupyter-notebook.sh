#!/bin/bash
set -e

JUPYTER_PASSWORD=''
if [ -f "/run/secrets/jupyter_password" ]
then
    JUPYTER_PASSWORD=$(cat /run/secrets/jupyter_password)
    echo "Found password secret"
    JUPYTER_PASSWORD=$(python3 -c "from notebook.auth import passwd; print(passwd('${JUPYTER_PASSWORD}'))")
fi
echo "Jupyter password: ${JUPYTER_PASSWORD}"

jupyter notebook --allow-root --ip='*' \
                 --port=${JUPYTER_PORT:-8888} \
                 --NotebookApp.token='' \
                 --NotebookApp.password="${JUPYTER_PASSWORD}"
