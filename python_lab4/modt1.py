#!/usr/bin/env python3
import csv

def csv_mod(file_name):
    with open(file_name) as csv_file:
        reader = csv.reader(csv_file, quoting=csv.QUOTE_ALL, skipinitialspace=True)

        for line in reader:
            nl = ' '.join(line)
            ns = ' '.join(nl.split()).replace('"', '')
            print(ns)
