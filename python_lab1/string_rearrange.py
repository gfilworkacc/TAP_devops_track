#!/usr/bin/env python3
import sys
string = sys.argv[1]
low = ''
upp = ''
for letter in string:
    if letter.islower():
        low+=letter
    else:
        upp+=letter
print(low+upp)
