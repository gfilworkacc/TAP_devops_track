# Python task for day three:

## 1. Write a Python class to convert an integer to a roman numeral.
## 2. Write class that list of number and outputs their sum. Behind the scenes, use reduce and lambda function.
## 3. In Adapter.py, please implement class Adapter, so that boiling process executes correctly, and we get Coffee time!

### Task 1:

```python
#!/usr/bin/env python3

num = int(input ('Enter integer to convert to Roman: '))

class solution:
    def roman(self, num):
        values = [1000, 900, 500, 400,100, 90, 50, 40,10, 9, 5, 4, 1]

        symbols = ["M", "CM", "D", "CD","C", "XC", "L", "XL",
                "X", "IX", "V", "IV", "I"]

        roman_number = ''
        value_index = 0

        while  num > 0:
            for _ in range(num // values[value_index]):
                roman_number += symbols[value_index]
                num -= values[value_index]
            value_index += 1
        return roman_number

print(solution().roman(num))
```

### Task 2:

```python
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
```

## Task 3:

```python
class EuropeanSocketInterface:
    def voltage(self): pass

    def live(self): pass

    def neutral(self): pass

    def earth(self): pass


# Adaptee
class Socket(EuropeanSocketInterface):
    def voltage(self):
        return 230

    def live(self):
        return 1

    def neutral(self):
        return -1

    def earth(self):
        return 0


# Target interface
class USASocketInterface:
    def voltage(self): pass

    def live(self): pass

    def neutral(self): pass

# The Adapter
class Adapter(USASocketInterface):
    def __init__(self, socket):
        self.socket = socket

    def voltage(self):
        return 110

    def live(self):
        return self.socket.live()

    def neutral(self):
        return self.socket.neutral()


# Client
class ElectricKettle:

    def __init__(self, power):
        self.power = power

    def boil(self):
        if self.power.voltage() > 110:
            print("Kettle on fire!")
        elif self.power.live() == 1 and self.power.neutral() == -1:
            print("Coffee time!")
        else:
            print("No power.")


def main():
    # Plug in
    socket = Socket()
    adapter = Adapter(socket)
    kettle = ElectricKettle(adapter)

    # Make coffee
    kettle.boil()

    return 0


if __name__ == "__main__":
    main()
```
