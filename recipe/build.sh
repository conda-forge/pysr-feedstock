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
# Turn off automatic precompilation since we do not package the ji files
# https://pkgdocs.julialang.org/v1/environments/#Project-Precompilation
export JULIA_PKG_PRECOMPILE_AUTO="0"

mkdir -p "${FAKEDEPOT}"
${PYTHON} -c 'import pysr; pysr.install();'

# Override OpenSpecFun_jll artifact with conda-forge binaries
openspecfun_artifact_hash=`julia -e "using SymbolicRegression; print(basename(SymbolicRegression.CoreModule.OperatorsModule.SpecialFunctions.OpenSpecFun_jll.artifact_dir))"`
echo "$openspecfun_artifact_hash = \"$PREFIX\"" >> "${FAKEDEPOT}/artifacts/Overrides.toml"
rm -rf "${FAKEDEPOT}/artifacts/${openspecfun_artifact_hash}"

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
unset JULIA_PKG_PRECOMPILE_AUTO

# # Copy the [de]activate scripts to $PREFIX/etc/conda/[de]activate.d.
# # This will allow them to be run on environment activation.
for CHANGE in "activate" "deactivate"
do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    cp "${RECIPE_DIR}/scripts/${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
done
