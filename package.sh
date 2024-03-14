#!/bin/bash

source version.sh
sudo ./build.sh $am64version
sudo ./create-wic.sh $am64version