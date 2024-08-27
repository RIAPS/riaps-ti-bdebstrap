#!/usr/bin/env bash

# CROSS_COMPILE environment variable comes from the bdebstrap command in scripts/build_distro.sh

# Set other environment variables to use the cross-compiler
export CC="${CROSS_COMPILE}gcc"
export CXX="${CROSS_COMPILE}g++"
export LD="${CROSS_COMPILE}ld"
export AR="${CROSS_COMPILE}ar"

echo "CC: ${CC}"
echo "CXX: ${CXX}"
echo "LD: ${LD}"
echo "AR: ${AR}"