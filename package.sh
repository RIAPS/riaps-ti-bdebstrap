#!/bin/bash

source version.sh
echo "Build step ..."
sudo ./build.sh $am64version
echo "Create SD Image ..."
sudo ./create-wic.sh $am64version

# Change root folders to jenkins to help future builds
sudo chown -R jenkins:jenkins build
sudo chown -R jenkins:jenkins logs
sudo chown -R jenkins:jenkins tools