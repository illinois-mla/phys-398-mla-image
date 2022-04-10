#!/bin/bash

# Ensure pip-tools is installed
python -m pip show pip-tools &> /dev/null
if [ "$?" == "1" ]; then
    python -m pip install --upgrade pip setuptools wheel
    python -m pip install --upgrade pip-tools
fi

pip-compile \
    --generate-hashes \
    --output-file requirements.lock \
    requirements.txt
