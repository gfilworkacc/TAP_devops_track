## 1. Modify wordlist.py so that:
## a) the final list only contains a single copy of each letter.
## b) use list comprehension instead simple for loops

```python
#!/usr/bin/env python3
wordlist = ['cat','dog','rabbit']
letterlist = []
for word in wordlist:
    for letter in word:
        letterlist.append(letter)
letterlist_as_set = set(letterlist)
print(letterlist_as_set)
```

```python
#!/usr/bin/env python3
wordlist = ['cat','dog','rabbit']
letterlist = []
for word in wordlist:
    for letter in word:
        letterlist.append(letter)
letterlist_as_set = set(letterlist)
print(letterlist_as_set)
```

## 2. Write a Python program to change Brad’s salary to 8500 in brad.py.

```python
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
```

## 3. Write a program to print the following start pattern using the for loop:

```
*
* *
* * *
* * * *
* * * * *
* * * *
* * *
* *
*
```

```python
#!/usr/bin/env python3
x = "* "
for time in range(1,6):
    print(time*x)
for time in reversed(range(1,5)):
    print(time*x)
```

## 4. Write Python script that takes string on input, and arrange the \ 
## characters of a string so that all lowercase letters should come first.
##   EXAMPLE INPUT:       PyNaTive
##   EXPECTED OUTPUT:     yaivePNT

```python
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
```
