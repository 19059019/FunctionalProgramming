90% - I would have preferred a longer discussion on why/when the suggested 
decoding fuction fails, especially in terms of the list of 50 commonly used words - i.e. issues
related to adding spaces to the specification and also when input is short.


# Homework 1

Output for:
```
runCrack (encode 3 "i prefer haskell over lolcode")
```
is
```
"i prefer haskell over lolcode"
```
 This is expected.
 
Output for:
```
runCrack (encode 3 "borborygmus") 
```
is
```
"borborygmus"
```
This is also expected.
## Top fifty words
When the top50 words are run through the crack this is the result:
```
["the","of","and","to","in","a","is","that","for","it","as","was","with","be","by","on","not","he","i","this","are","or","his","from","at","which","but","have","an","had","they","you","were","their","one","all","we","can","her","has","there","been","if","more","when","will","would","who","so","no"]
```
maps to
```
["l x","i ","n q","e "," e","e","eo","sg s","r c","it","i ","v r","cp o","eh","ea","a ","z e","he","e","l ak","j n","eh","z j","rc y"," s","tef e","h z","g ud","n ","g c","oc t","j f","en n","oc dm","a r","p  "," i","b m","c m","g r","oc m ","x  i","he","y cq","rc i","n cc","would","o g","ea"," a"]
```
This can be repriduced with the function topFifty.

This may look incorrect, due to only "he", "it" and would mapping to themselves, but all of these outputs are words contained in the words_alpha.txt dictionary that have been weighted heavily due to 
them containing more spaces. The result with more spaces is chosen by my chsq because of the huge percentage frequency of spaces in the english language.