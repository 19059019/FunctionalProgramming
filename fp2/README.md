75% Suggested improvements:
*  Include test cases for larger examples
*  Use the Haskell Stack Tool and setup project and test cases in a suitable way
*  Instead of multiplying probabilities, add logs of probabilities - will avoid underflow issues in larger examples

# Functional Programing Homework 2: Folds, Folds and More Folds
### Michael Shepherd, 19059019

The goal of this homework was to use folds in Haskell to implement the Viterbi algorithm. I believe that I have used as many folds as I possible can to do as much as I possibly can and here are my results:

## Village Doctor Problem:
This is the problem that is shown on wikipedia, which uses the following values:
```
obs = ('normal', 'cold', 'dizzy')
states = ('Healthy', 'Fever')
start_p = {'Healthy': 0.6, 'Fever': 0.4}
trans_p = {
   'Healthy' : {'Healthy': 0.7, 'Fever': 0.3},
   'Fever' : {'Healthy': 0.4, 'Fever': 0.6}
   }
emit_p = {
   'Healthy' : {'normal': 0.5, 'cold': 0.4, 'dizzy': 0.1},
   'Fever' : {'normal': 0.1, 'cold': 0.3, 'dizzy': 0.6}
   }
```
This can be run with my program by calling the _doctor_ function and the output of that function is as follows:
```
1.5119999999999998e-2
"Path: Healthy  Healthy  Fever "
```
This is expected, and conforms to the output calculated on wikipedia. This would lead me to believe that my viterbi algorithm that was created with many folds is working correctly.

## The Coin Flip Problem:
This is the problem that is shown in the notes linked, which uses the following values:
```
obs = ('Heads', 'Tails')
states = ('Fair', 'Loaded')
start_p = {'Fair': 0.5, 'Loaded': 0.5}
trans_p = {
   'Fair' : {'Fair': 0.6, 'Loaded': 0.4},
   'Loaded' : {'Fair': 0.4, 'Loaded': 0.6}
   }
emit_p = {
   'Fair' : {'Heads': 0.5, 'Tails': 0.5},
   'Loaded' : {'Heads': 0.8, 'Tails': 0.2}
   }
```
This can be run with my program by calling the _coin_ function and the output of that function is as follows:
```
4.892236185600002e-6
"Path: Fair  Fair  Fair  Fair  Loaded  Loaded  Fair  Fair  Loaded  Fair  Loaded "
```
This does not agree with the slides, but agrees with the notebook answers that were linked to the slides, which shows me that the slides were incorrect.

## Conclusion
Folds are an extremely useful and versatile way to functionally solve problems that require some sort of iteration. I thoroughly enjoyed finding the exciting bounds that I could myself with learnign such an exciting new concept.