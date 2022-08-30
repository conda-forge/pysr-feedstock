# This should execute after julia_activate.sh
# Assumes that the JULIA_DEPOT_PATH ends in a colon
export JULIA_DEPOT_PATH="${JULIA_DEPOT_PATH}${CONDA_PREFIX}/share/SymbolicRegression.jl/depot:"

# build.sh will insert a line to set JULIA_PROJECT to pysr-${VERSION}
