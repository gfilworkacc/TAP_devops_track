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
