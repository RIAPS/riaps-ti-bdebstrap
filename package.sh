#!/bin/bash

source version.sh
sudo ./build.sh $am64version
sudo ./create-wic.sh $am64version

# Change root folders to jenkins to help future builds
sudo chown -R jenkins:jenkins build
sudo chown -R jenkins:jenkins logs
sudo chown -R jenkins:jenkins tools