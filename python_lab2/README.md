## Python lab 2:
## 1. implement TODOs in logic_gates.py
## 2. implement TODOs in fraction.py

## Modified logic_gates.py:

```python
class LogicGate:

    def __init__(self, name):
        self.name = name
        self.output = None

    def getLabel(self):
        return self.name

    def getOutput(self):
        self.output = self.performGateLogic()
        return self.output


class BinaryGate(LogicGate):

    def __init__(self, name):
        super(BinaryGate, self).__init__(name)

        self.pinA = None
        self.pinB = None

    def getPinA(self):
        if self.pinA == None:
            return int(input("Enter Pin A input for gate "+self.getLabel()+"-->"))
        else:
            return self.pinA.getFrom().getOutput()

    def getPinB(self):
        if self.pinB == None:
            return int(input("Enter Pin B input for gate "+self.getLabel()+"-->"))
        else:
            return self.pinB.getFrom().getOutput()

    def setNextPin(self,source):
        if self.pinA == None:
            self.pinA = source
        else:
            if self.pinB == None:
                self.pinB = source
            else:
                print("Cannot Connect: NO EMPTY PINS on this gate")


class AndGate(BinaryGate):

    def __init__(self, name):
        BinaryGate.__init__(self, name)

    def performGateLogic(self):

        a = self.getPinA()
        b = self.getPinB()
        if a==1 and b==1:
            return 1
        else:
            return 0

class OrGate(BinaryGate):

    def __init__(self, name):
        BinaryGate.__init__(self, name)

    def performGateLogic(self):

        a = self.getPinA()
        b = self.getPinB()
        if a ==1 or b==1:
            return 1
        else:
            return 0

class UnaryGate(LogicGate):

    def __init__(self, name):
        LogicGate.__init__(self, name)

        self.pin = None

    def getPin(self):
        if self.pin == None:
            return int(input("Enter Pin input for gate "+self.getLabel()+"-->"))
        else:
            return self.pin.getFrom().getOutput()

    def setNextPin(self,source):
        if self.pin is None:
            self.pin = source
        else:
            print("Cannot Connect: NO EMPTY PINS on this gate")


class NotGate(UnaryGate):

    def __init__(self, name):
        UnaryGate.__init__(self, name)

    def performGateLogic(self):
        if self.getPin():
            return 0
        else:
            return 1


class Connector:

    def __init__(self, fgate, tgate):
        self.fromgate = fgate
        self.togate = tgate

        tgate.setNextPin(self)

    def getFrom(self):
        return self.fromgate

    def getTo(self):
        return self.togate


'''TODO implement
NandGates work like AndGates that have a Not attached to the output.'''
class NandGate(BinaryGate):

   def __init__(self, name):
       BinaryGate.__init__(self, name)

   def performGateLogic(self):

       a = self.getPinA()
       b = self.getPinB()
       if a==1 and b==1:
           return 0
       else:
           return 1

'''TODO implement
NorGates work lake OrGates that have a Not attached to the output.'''
class NorGate(BinaryGate):

   def __init__(self, name):
       BinaryGate.__init__(self, name)

   def performGateLogic(self):

       a = self.getPinA()
       b = self.getPinB()
       if a==0 or b==0:
           return 1
       else:
           return 0

def main():
   g1 = AndGate("G1")
   g2 = AndGate("G2")
   g3 = OrGate("G3")
   g4 = NotGate("G4")
   g5 = NandGate("G5")
   g6 = NorGate("G6")
   #c1 = Connector(g1,g3)
   #c2 = Connector(g2,g3)
   #c3 = Connector(g3,g4)
   #print(g4.getOutput())

'''TODO
Create a series of gates that prove the following equality: 
NOT (( A and B) or (C and D)) is that same as NOT( A and B ) and NOT (C and D).

Make sure to use some of your new gates in the simulation.'''

   c4 = Connector(g1,g6)
   c5 = Connector(g2,g6)
   print(g6.getOutput())
   
   c7 = Connector(g1,g5)
   c8 = Connector(g2,g5)
   print(g5.getOutput())


main()
```

## Modified fraction.py

```python
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
```
