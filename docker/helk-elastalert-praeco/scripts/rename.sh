#!/bin/bash

for f in *.yml; do
    mv -- "$f" "$(basename -- "$f" .yml).yaml"
done
