#!/bin/sh

# Restore JULIA_DEPOT_PATH to pre-pysr activation
export JULIA_DEPOT_PATH=$JULIA_DEPOT_PATH_PYSR_BACKUP

unset JULIA_DEPOT_PATH_PYSR_BACKUP

if [ -z $JULIA_DEPOT_PATH ]; then
    unset JULIA_DEPOT_PATH
fi
