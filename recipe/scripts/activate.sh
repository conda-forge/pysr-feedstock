#!/bin/sh

export JULIA_DEPOT_PATH_PYSR_BACKUP=${JULIA_DEPOT_PATH:-}

# This should execute after julia_activate.sh
# Assumes that the JULIA_DEPOT_PATH ends in a colon
export JULIA_DEPOT_PATH="${JULIA_DEPOT_PATH}${CONDA_PREFIX}/share/pysr/depot:"
