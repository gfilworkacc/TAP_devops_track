#!/usr/bin/env python3
import sys
import functools

try:
    limit = int(input('\nEnter upper range for the number list: '))
    limit = limit + 1
except ValueError:
    sys.exit('Invalid decimal number. Script exited.')

class NumbersList:
    def __init__(self, limit):
        self.limit = limit

    def sum_list(self):
        print('\nHere is the list: ', list(num for num in range(limit)),'\n')
        
        print('Sum of the list is: ', functools.reduce(lambda x, y: x+y, list(num for num in range(limit))), '\n') 

nums = NumbersList(limit)
nums.sum_list()
