#!/bin/bash

set -euxo pipefail

${PYTHON} -m pip install . -vv

# Start a fake Julia depot
FAKEDEPOT="${PREFIX}/share/SymbolicRegression.jl/fake_depot"
export JULIA_DEPOT_PATH="${FAKEDEPOT}"
# Set the JULIA_PROJECT so PyCall.jl gets installed into it
# FIXME: Get version correctly
export JULIA_PROJECT="@pysr-${PKG_VERSION}"
mkdir -p "${FAKEDEPOT}"
${PYTHON} -c 'import pysr; pysr.install();'

# Copy packages, artifacts, environments, and conda dirs
# into the real depot that we will package
SRDEPOT="${PREFIX}/share/SymbolicRegression.jl/depot"
mkdir -p "${SRDEPOT}"
mv "${FAKEDEPOT}/packages" "${SRDEPOT}/packages"
mv "${FAKEDEPOT}/artifacts" "${SRDEPOT}/artifacts"
mv "${FAKEDEPOT}/environments" "${SRDEPOT}/environments"
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
