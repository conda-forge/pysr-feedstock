export JULIA_DEPOT_PATH_PYSR_BACKUP=${JULIA_DEPOT_PATH:-}
export JULIA_PROJECT_PYSR_BACKUP=${JULIA_PROJECT:-}
export JULIA_LOAD_PATH_PYSR_BACKUP=${JULIA_LOAD_PATH:-}
export PYSR_PROJECT_BACKUP=${PYSR_PROJECT:-}

# This should execute after julia_activate.sh
# Assumes that the JULIA_DEPOT_PATH ends in a colon
export JULIA_DEPOT_PATH="${JULIA_DEPOT_PATH}${CONDA_PREFIX}/share/pysr/depot:"

# For testing purposes to see if we can macos tests to pass
# See https://github.com/conda-forge/julia-feedstock/pull/221
if [[ $OSTYPE == 'darwin'* ]]; then
  export JULIA_SSL_CA_ROOTS_PATH=""
else
fi

# build.sh will insert lines to set JULIA_PROJECT to @pysr-${VERSION},
# to insert that into the project stack via JULIA_LOAD_PROJECT, ans
# set PYSR_PROJECT
