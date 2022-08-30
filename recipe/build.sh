#!/bin/bash

set -euxo pipefail

${PYTHON} -m pip install . -vv

# Build an accessory Julia depot containing all of
# SymbolicRegression.jl's dependencies

# Start a fake Julia depot
FAKEDEPOT="${PREFIX}/share/SymbolicRegression.jl/fake_depot"
export JULIA_DEPOT_PATH="${FAKEDEPOT}"
# Set the JULIA_PROJECT so PyCall.jl gets installed into it
export JULIA_PROJECT="@pysr-${PKG_VERSION}"
mkdir -p "${FAKEDEPOT}"
${PYTHON} -c 'import pysr; pysr.install();'

# Copy packages, artifacts, environments, and conda dirs
# into the real depot that we will package
SRDEPOT="${PREFIX}/share/SymbolicRegression.jl/depot"
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
export JULIA_DEPOT_PATH="${SRDEPOT}"

# # Copy the [de]activate scripts to $PREFIX/etc/conda/[de]activate.d.
# # This will allow them to be run on environment activation.
for CHANGE in "activate" "deactivate"
do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    cp "${RECIPE_DIR}/scripts/${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
done

# Activate the versioned pysr julia project upon activate.
# The activated Projewct.toml should contain PyCall.jl, SymbolicRegression.jl,
# and ClusterManagers.jl
"export JULIA_PROJECT=\"@pysr-${PKG_VERSION}\"" >> "${PREFIX}/etc/conda/activate.d/${PKG_NAME}_activate.sh"
