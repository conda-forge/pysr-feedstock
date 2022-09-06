#!/bin/bash

set -euxo pipefail

${PYTHON} -m pip install . -vv

# Build an accessory Julia depot containing all of
# SymbolicRegression.jl's dependencies

# Start a fake Julia depot
FAKEDEPOT="${PREFIX}/share/pysr/fake_depot"
export JULIA_DEPOT_PATH="${FAKEDEPOT}"
# Set the JULIA_PROJECT so PyCall.jl gets installed into it
export JULIA_PROJECT="@pysr-${PKG_VERSION}"
mkdir -p "${FAKEDEPOT}"
${PYTHON} -c 'import pysr; pysr.install();'

# Copy packages, artifacts, environments, and conda dirs
# into the real depot that we will package
SRDEPOT="${PREFIX}/share/pysr/depot"
mkdir -p "${SRDEPOT}"

# Select particular depot subdirectories to package
# Julia package source code and potentially deps.jl
mv "${FAKEDEPOT}/packages" "${SRDEPOT}/packages"
# Binary dependencies including openspecfun and LLVMExtra
mv "${FAKEDEPOT}/artifacts" "${SRDEPOT}/artifacts"
# Julia environment pysr-${VERSION} with PyCall.jl, SymbolicRegression.jl
# and ClusterManagers.jl
mv "${FAKEDEPOT}/environments" "${SRDEPOT}/environments"
# The conda directory should only contain a single file,
# deps.jl, which configures Conda.jl
mv "${FAKEDEPOT}/conda" "${SRDEPOT}/conda"

# Destroy the fake depot
rm -rf "${FAKEDEPOT}"
# We should not depend on these variables further in the build phase
unset JULIA_DEPOT_PATH
unset JULIA_PROJECT

# # Copy the [de]activate scripts to $PREFIX/etc/conda/[de]activate.d.
# # This will allow them to be run on environment activation.
for CHANGE in "activate" "deactivate"
do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    cp "${RECIPE_DIR}/scripts/${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
done

# THE FOLLOWING ACTION HAS BEEN DISABLED
# Activate the versioned pysr julia project upon activate.
# Also add the pysr project into the project stack
# The activated Project.toml should contain PyCall.jl, SymbolicRegression.jl,
# and ClusterManagers.jl
# ACTIVATE_SCRIPT="${PREFIX}/etc/conda/activate.d/${PKG_NAME}_activate.sh"
# echo "export PYSR_PROJECT=\"@pysr-${PKG_VERSION}\"" >> $ACTIVATE_SCRIPT
# echo "export JULIA_PROJECT=\$PYSR_PROJECT" >> $ACTIVATE_SCRIPT
# If JULIA_LOAD_PATH were "@:@myproject:@stdlib" it would become "@:$PYSR_PROJECT:@myproject:@stdlib"
# echo "# Add PYSR_PROJECT to the project stack" >> $ACTIVATE_SCRIPT
# echo "export JULIA_LOAD_PATH=\${JULIA_LOAD_PATH/@/@:\$PYSR_PROJECT}" >> $ACTIVATE_SCRIPT

