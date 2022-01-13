#!/usr/bin/env python3
import sys

try:
    if len(sys.argv[1]) > 0 and len(sys.argv) == 2:
        search_pattern = sys.argv[1]
        pass_file = '/etc/passwd'
    else:
        sys.exit("Provide only one username.")
except IndexError:
    sys.exit("Provide username.")

with open(pass_file, 'r') as f:
    lines = f.readlines()
    for line in lines:
        if search_pattern in line.split(":")[0]:
            print(line.split(":")[4])
