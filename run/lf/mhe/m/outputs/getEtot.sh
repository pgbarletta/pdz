#!/bin/bash

# Extract total energy from output file from amber minimization 
cat "$1" | grep -A1 NSTEP | awk '{print $1"\t\t\t"$2}' | grep [1-9] 
