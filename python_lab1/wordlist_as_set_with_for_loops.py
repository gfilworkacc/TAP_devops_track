#!/usr/bin/env python3
wordlist = ['cat','dog','rabbit']
letterlist = []
for word in wordlist:
    for letter in word:
        letterlist.append(letter)
letterlist_as_set = set(letterlist)
print(letterlist_as_set)
