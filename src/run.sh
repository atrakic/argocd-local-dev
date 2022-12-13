#!/bin/bash

args="$@"
args="$@ -H 0.0.0.0 -p 8000"

file=/db.json
if [ -f $file ]; then
    echo "Found db.json, trying to open"
    args="$args $file"
fi

file=/routes.json
if [ -f $file ]; then
    echo "Found db.json, trying to open"
    args="$args --routes $file"
fi

file=/file.js
if [ -f $file ]; then
    echo "Found file.js seed file, trying to open"
    args="$args file.js"
fi

json-server $args
