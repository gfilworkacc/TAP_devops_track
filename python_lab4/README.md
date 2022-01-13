## Task 1:

### Sample input file:
'''bash
"Name",     "Sex", "Age", "Height (in)", "Weight (lbs)"
"Alex",       "M",   41,       74,      170
"Bert",       "M",   42,       68,      166
"Carl",       "M",   32,       70,      155
"Dave",       "M",   39,       72,      167
"Elly",       "F",   30,       66,      124
"Fran",       "F",   33,       66,      115
"Gwen",       "F",   26,       64,      121
"Hank",       "M",   30,       71,      158
"Ivan",       "M",   53,       72,      175
"Jake",       "M",   32,       69,      143
"Kate",       "F",   47,       69,      139
"Luke",       "M",   34,       72,      163
"Myra",       "F",   23,       62,       98
"Neil",       "M",   36,       75,      160
"Omar",       "M",   38,       70,      145
"Page",       "F",   31,       67,      135
"Quin",       "M",   29,       71,      176
"Ruth",       "F",   28,       65,      131
'''

### Module task 1:

'''python
#!/usr/bin/env python3
import csv

def csv_mod(file_name):
    with open(file_name) as csv_file:
        reader = csv.reader(csv_file, quoting=csv.QUOTE_ALL, skipinitialspace=True)

        for line in reader:
            nl = ' '.join(line)
            ns = ' '.join(nl.split()).replace('"', '')
            print(ns)
'''

### Task 1:

'''python
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
'''

### Module task 2:

'''python
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
'''

### Task 2:

'''python
#!/usr/bin/env python3
import modt2

def main():
    modt2.list_generation()
    modt2.list_to_csv()
    modt2.csv_to_dict()

main()
'''

### Module task 4:

'''python 
#!/usr/bin/env python3

def bold(f):
    def d():
        return "<b> " + f() + " </b>"
    return d

def underline(f):
    def d():
        return "<u> " + f() + " </u>"
    return d

def italic(f):
    def d():
        return "<i> " + f() + " </i>"
    return d
'''

### Task 4:

'''python
#!/usr/bin/env python3
from modt4 import bold, underline, italic

@bold
@underline
@italic
def hello():
    return "hello world"

def main():
    print(hello())

main()
'''

### Task 5:

'''python
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
'''
