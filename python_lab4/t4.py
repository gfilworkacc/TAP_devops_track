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
