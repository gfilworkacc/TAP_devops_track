#!/usr/bin/env python3
import random
import csv

ls = []
output_file = 't2.csv'

def list_generation():
#Generating list of lists with numbers in range from 5 to 10
    for num in range(random.randrange(5,10)):
        ls.append([])

    for each in ls:
        for num in range(random.randrange(5,10)):
            each.append(num)

    print("Randomly generated list of lists: \n\n",ls,"\n")

#Output the list to csv:

def list_to_csv():
    ls_lenght = len(ls)
    ls_header = []

    for n in range(0, ls_lenght+1):
        ls_num = "List number "+str(n)
        ls_header.append(ls_num)

    comp = list(zip(ls_header, ls))

    with open(output_file, "w", newline="\n") as f:
        writer = csv.writer(f)
        writer.writerows(comp)

#Here I tried to use the first column of the csv file for dictonary key, 
#but failed. Leaving to debug for later.

def csv_to_dict():

    with open(output_file, 'r') as o:
        reader = csv.DictReader(o, delimiter=':', skipinitialspace=True)
        for row in reader:
            print(row)
