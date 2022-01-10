#!/usr/bin/env python3
wordlist = ['cat','dog','rabbit']
letterlist = []
letterlist = [[letter for letter in word] for word in wordlist] 
letterlist = [each for letter in letterlist for each in letter] 
print(set(letterlist))
