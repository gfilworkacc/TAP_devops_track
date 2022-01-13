#!/usr/bin/env python3
import modt1
import sys
import os

try:
    file_name = sys.argv[1]
    if os.path.isfile(file_name) and file_name.endswith(".csv"):
        with open(file_name, 'r') as f:
            file_content = f.read()
            print("CSV file content: \n\n",file_content)
except:
    sys.exit('Provide valid CSV file.')

def main():
    modt1.csv_mod(file_name)

main()
