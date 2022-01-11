import sys

def gcd(m,n):
    try:
        while m%n != 0:
            oldm = m
            oldn = n

            m = oldn
            n = oldm%oldn
        return n
    except ZeroDivisionError:
        sys.exit('\nDenominator value should not be equal to 0.\
                  \nScript exited.\n')

class Fraction:
   # TODO implement comparison operators >, < and numerical operators *, / and -
    def __init__(self,top,bottom):
        self.num = top
        self.den = bottom

    def __str__(self):
        return str(self.num)+"/"+str(self.den)

    def show(self):
        print(self.num,"/",self.den)

    def __add__(self,otherfraction):
        newnum = self.num*otherfraction.den + \
                     self.den*otherfraction.num
        newden = self.den * otherfraction.den
        common = gcd(newnum,newden)
        return Fraction(newnum//common,newden//common)

    def __sub__(self, otherfraction):
        newnum = self.num * otherfraction.den - self.den * otherfraction.num
        newden = self.den * otherfraction.den
        common = gcd(newnum,newden)
        return Fraction(newnum//common,newden//common)

    def __mul__(self, otherfraction):
        newnum = self.num * otherfraction.num 
        newden = self.den * otherfraction.den 
        common = gcd(newnum,newden)
        return Fraction(newnum//common,newden//common)
        
    def __truediv__(self, otherfraction):
        newnum = self.num * otherfraction.den 
        newden = self.den * otherfraction.num 
        common = gcd(newnum,newden)
        return Fraction(newnum//common,newden//common)

    def __eq__(self, other):
        firstnum = self.num * other.den
        secondnum = other.num * self.den
        return firstnum == secondnum

    def __gt__(self, other):
        firstnum = self.num * other.den
        secondnum = other.num * self.den
        return firstnum > secondnum

    def __lt__(self, other):
        firstnum = self.num * other.den
        secondnum = other.num * self.den
        return firstnum < secondnum


x = Fraction(1,2)
y = Fraction(2,0)
print('\nThese are the fractions hard coded values:\n')
print('x = ', x,'\n\ny = ',y)
print('\nAddition result: ', x+y)
print('\nSubtraction result: ', x-y)
print('\nMultiplication result: ',x*y)
print('\nDivision result: ', x/y)
print('\nAre the fractions equal: ', x == y)
print('\nIs x greater that y: ', x > y)
print('\nIs x smaller that y: ', x < y, '\n')
