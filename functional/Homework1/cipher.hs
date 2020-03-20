-- Caeser cipher example from chapter 5 of Programming in Haskell,
-- Graham Hutton, Cambridge University Press, 2016.

import Data.List
import Data.Char
import System.IO

-- Encoding and decoding

let2int :: Char -> Int
let2int c
    | c == ' ' = 26
    | otherwise = ord c - ord 'a'

int2let :: Int -> Char
int2let n
    | n == 26 = ' '
    | otherwise = chr (ord 'a' + n)

shift :: Int -> Char -> Char
shift n c 
		| n == 0 = c
        | isLower c = int2let ((let2int c + n) `mod` 27)
        | c == ' ' = int2let(n - 1)
        | otherwise = c

encode :: Int -> String -> String
encode n xs = [shift n x | x <- xs]

-- Frequency analysis

table :: [Float]
table = [6.5, 1.2, 2.2, 3.5, 10.4, 2.0, 1.6, 4.9, 5.6,
        0.1, 0.5, 3.3, 2.0, 5.6, 6.0, 1.4, 0.1, 5.0,
        5.2, 7.3, 2.3, 0.8, 1.7, 0.1, 1.5, 0.1, 19.2]

lowers :: String -> Int
lowers xs = length [x | x <- xs, x >= 'a' && x <= 'z' || x == ' ']

count :: Char -> String -> Int
count x xs = length [x' | x' <- xs, x == x']

percent :: Int -> Int -> Float
percent n m = (fromIntegral n / fromIntegral m) * 100

freqs :: String -> [Float]
freqs xs = [percent (count x xs) n | x <- ['a'..'z'] ++ [' ']]
           where n = lowers xs

chisqr :: [Float] -> [Float] -> Float
chisqr os es = sum [((o-e)^2)/e | (o,e) <- zip os es]

rotate :: Int -> [a] -> [a]
rotate n xs = drop n xs ++ take n xs

positions :: Eq a => a -> [a] -> [Int]
positions x xs = [i | (x',i) <- zip xs [0..n], x == x']
                 where n = length xs - 1

crack dict x = chis (crack' dict x)

-- Run chisq on the set of decodings returned from crack'
chis ::  [String] -> String 
chis xss = head [xss !! n | n <- [0..(length xss) - 1], freqss !! n == min]
			where
			 min = minimum freqss
			 freqss = [chisqr (freqs str) table | str <- xss]

-- Return all decodings with the most amount of recognised words
crack' xss xs =  [decss !! n | n <- [0..26], lengths !! n == max]
					where
					max = maximum lengths
					lengths = [length (ns `intersect` xss) | ns <- [words n | n <- decss]];
					decss = [encode n xs| n <- [0..26]]

decodeList dicts xs = [chis (crack' dicts x)|x<-xs]

decodeWord dict word = chis (crack' dict word)

decodeShiftedByThree dict xs = [crack dict (encode 3 x)| x<-xs]

topFifty = do
            contents <-readFile "words_alpha.txt"
            let dict =  words contents
            contents1 <-readFile "top50.txt"
            let fifty =  words contents1
            let out = decodeShiftedByThree dict fifty
            print(fifty)
            print(out)
             

runCrack s = do
                contents <-readFile "words_alpha.txt"
                let dict =  words contents
                print(crack dict s)

