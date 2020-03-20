90%. Using Stack would have improve the homework submission.
Also an issue with unary minus, for example:
```
*Main> eval "-1-2-3"
*** Exception: Prelude.head: empty list
```

# Functional Programming Homework 3
## Tasks
Extend/modify parsing.hs to support the following arithmetic operations/extensions.
* The additional operators: -, /, ^
* Floating point numbers - and you may assume all numbers are floating point
* Allow an expresion (that should be evaluated) to consist of multiple single expressions, separated by newlines, where the value of the last expression is returned, and previous expressions (if any) define variable values.

## How to run

To use the parser, open new.hs in ghci:
```
ghci new.hs
```
One can then perform mathematical functionality using the following format:
```
eval "2 + 2"
4.0
```
One can use variables in this functionality with the following format:
```
parse equations "y = 20 \n x = y+11 \n var = x + 7*y \n var + 17"
[(188.0,"")]
```
## Discussion

When looking at the parse.hs file that was provided, it became glaringly obvious that it would not be simple to implement subtraction, power and division. This is because subtraction, power and division are all exclusively left-associative. What this means is that although addition and multiplication can work with a parser that only allows for right associativity, we would need to make the parser left associative. To do this, I used ideas of chaining from the paper **FUNCTIONAL PEARLS** _Monadic Parsing in Haskell_ by Graham Hutton and Erik Meijer. This allowed me to implement +, -, * and / correctly.

This left me with the problem of having a left associative parser, but needing to implement power, which is a right associative operand. This was simply solved by using ideas from the original parser given to add a seperate powRule function that evaluated ^ separately from the other operands and chaining that in with the term function.

The next step is to implement floating points. I first changed all of my functions to return floats so that the mathematical operations could result in a float. I then created a float function to replace the nat function that I had been using to give values to get values from the factor function. This float function handles the cases of numbers of the forms "x.x", "-x.x" and adds the natural number on the left to the nutuaral number or the right together to return the floating point value.

These steps can be illustrated as working with the following examples:
```
eval "2/4/3"
0.16666667

eval "2-4-3"
-5.0

"2+4+3"
9.0

eval "2^4^3"
1.8446744e19

"2*4*3"
24.0

eval "2.4^4*3^3/4"
223.94884

eval "2.4^4*3^3/0"
Infinity
```

I Then proceeded to the problem of parsing equations. This is done by passing a map between functions. The map maps a string identifier to an evaluated expression and is delimited by the "=" sign. The lines are delimited by the newline character. To allow for the map to be used later, I changed my factor function to lookup any word made up of only letters (upper and lowercase). This allowes the factor function to use the mapped value of an identifier that it finds in the equation, if the identifier exists in the map that is being passed around.

The final step was to remove all of the whitespace (except for newlines) so that equations can be read in more naturally. This was done by changing the space function to look only be true if the character encountered is one of [' ', '\t', '\v', '\r'].

These steps can be illustrated as working with the following examples:
```
parse equations "y = 20 \n x = y+11 \n var = x + 7*y \n var + 17"
[(188.0,"")]

parse equations "y = 20\t\t\t\t \n x = y+11 \n                                var = x + 7*y \n var +\v\v\v\v\r\r 17"
[(188.0,"")]
```


