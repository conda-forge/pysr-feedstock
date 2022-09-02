#!/bin/sh

# Restore JULIA_DEPOT_PATH to pre-pysr activation
export JULIA_DEPOT_PATH=$JULIA_DEPOT_PATH_PYSR_BACKUP

# Restore JULIA_PROJECT to pre-pysr activation
export JULIA_PROJECT=$JULIA_PROJECT_PYSR_BACKUP

# Restore JULIA_LOAD_PATH to pre-pysr activation
export JULIA_LOAD_PATH=$JULIA_LOAD_PATH_PYSR_BACKUP

# Restore PYSR_PROJECT to pre-pysr activation
export PYSR_PROJECT=$PYSR_PROJECT_BACKUP

unset JULIA_DEPOT_PATH_PYSR_BACKUP
unset JULIA_PROJECT_PYSR_BACKUP
unset JULIA_LOAD_PATH_PYSR_BACKUP
unset PYSR_PROJECT_BACKUP

if [ -z $JULIA_DEPOT_PATH ]; then
    unset JULIA_DEPOT_PATH
fi
if [ -z $JULIA_PROJECT ]; then
    unset JULIA_PROJECT
fi
if [ -z $JULIA_LOAD_PATH ]; then
    unset JULIA_LOAD_PATH
fi
if [ -z $PYSR_PROJECT ]; then
    unset PYSR_PROJECT
fi
