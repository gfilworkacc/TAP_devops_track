#!/usr/bin/env python3
sample_dict = {
    'emp1': {'name': 'John', 'salary': 7500},
    'emp2': {'name': 'Emma', 'salary': 8000},
    'emp3': {'name': 'Brad', 'salary': 500}
}
for employee in sample_dict.items():
    if employee[1]['name'] == 'Brad':
        employee[1]['salary']=8500

brad_only = [employee for employee in sample_dict.items() \
            if employee[1]['name'] == 'Brad']

print(brad_only[0][1])
