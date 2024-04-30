#!/usr/bin/env bash
set -e

apt-get update
export KERNEL_DIR=/usr/src/linux-headers-6.1.80-rt26-k3-rt 
apt-get install linux-image-6.1.80-rt26-k3-rt-dirty=6.1.80-rt26-k3-rt-dirty-8 linux-headers-6.1.80-rt26-k3-rt-dirty=6.1.80-rt26-k3-rt-dirty-8 linux-libc-dev=6.1.80-rt26-k3-rt-dirty-8 -y
