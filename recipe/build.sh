#!/bin/bash

set -euxo pipefail

${PYTHON} -m pip install . -vv

${PYTHON} -c 'import pysr; pysr.install()'

ls ${PREFIX}/share/julia

rm -rf ${PREFIX}/share/julia/!(packages|artifacts)

ls ${PREFIX}/share/julia
