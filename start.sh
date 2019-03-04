#!/usr/bin/env bash
if [[ "$#" -ne 1 ]]; then
    echo -e >&2 "Unexpected number of parameters.\nUsage:\n\t`basename "$0"` STATION_NAME"
else
    if [[ ! -d venv ]]; then
        echo -e >&2 "venv is missing. did you run setup.sh?"
    else
        venv/bin/python3 oebb-stations.py $1
    fi
fi
