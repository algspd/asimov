#!/bin/bash
extension="${1##*.}"
filename="${1%.*}"
bin/slic3r --nozzle-diameter 10 --layer-height 0.1 --export-svg $1 -o $filename.svg
