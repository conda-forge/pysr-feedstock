#!/bin/sh

export JULIA_DEPOT_PATH_PYSR_BACKUP=${JULIA_DEPOT_PATH:-}

# This should execute after julia_activate.sh
# Assumes that the JULIA_DEPOT_PATH ends in a colon
export JULIA_DEPOT_PATH="${JULIA_DEPOT_PATH}${CONDA_PREFIX}/share/pysr/depot:"

# Ensure pysr is installed in the current Julia environment
if [ -z "${JULIA_PROJECT}" ]
then
    active_julia_project=`julia -e "print(Base.active_project())"`
else
    active_julia_project="${JULIA_PROJECT}"
fi
python -c "import pysr; pysr.install(julia_project=\"$active_julia_project\")"
