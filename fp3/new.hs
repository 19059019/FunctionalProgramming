import Control.Applicative -- Otherwise you can't do the Applicative instance.
import Control.Monad

import           Data.Char
import qualified Data.Map            as M
import           Data.Maybe

infixr 5 +++
newtype Parser a = P (String -> [(a, String)])

instance Functor Parser where
  fmap = liftM

instance Applicative Parser where
  pure  = return
  (<*>) = ap


instance Monad Parser where
    return v = P (\inp -> [(v,inp)])
    p >>= f = P (\inp ->
                     case parse p inp of
                       [(v, out)] -> parse (f v) out
                       [] -> [])

instance Alternative Parser where
    (<|>) = mplus
    empty = mzero

instance MonadPlus Parser where
    mzero                      =  P (\inp -> [])
    p `mplus` q                =  P (\inp -> case parse p inp of
                                               []        -> parse q inp
                                               [(v,out)] -> [(v,out)])


-- Basic parser
parse :: Parser a -> String -> [(a, String)]
parse (P p) inp = p inp

failure                       :: Parser a
failure                       =  mzero

item                          :: Parser Char
item                          =  P (\inp -> case inp of
                                              []     -> []
                                              (x:xs) -> [(x,xs)])

float :: Parser Float
float = (do char '-'
            xs <- many1 digit
            s <- symb "."
            ys <- many1 digit
            return (-read (xs ++ (s ++ ys))))
          +++ (do xs <- many1 digit
                  s <- symb "."
                  ys <- many1 digit
                  return (read (xs ++ (s ++ ys))))
          +++ nat

nat                           :: Parser Float
nat                           =  do xs <- many1 digit
                                    return (read xs)

digit                         :: Parser Char
digit                         =  sat isDigit

(+++)                         :: Parser a -> Parser a -> Parser a
p +++ q                       =  p `mplus` q


sat                           :: (Char -> Bool) -> Parser Char
sat p                         =  do x <- item
                                    if p x then return x else failure

lower                         :: Parser Char
lower                         =  sat isLower

upper                         :: Parser Char
upper                         =  sat isUpper

letter                        :: Parser Char
letter                        =  sat isAlpha

alphanum                      :: Parser Char
alphanum                      =  sat isAlphaNum

char                          :: Char -> Parser Char
char x                        =  sat (== x)

string                        :: String -> Parser String
string []                     =  return []
string (x:xs)                 =  do char x
                                    string xs
                                    return (x:xs)
          
                                    
symb :: String -> Parser String
symb cs = token (string cs)

many'                          :: Parser a -> Parser [a]
many' p                        =  many1 p +++ return []

many1                         :: Parser a -> Parser [a]
many1 p                       =  do v  <- p
                                    vs <- many' p
                                    return (v:vs)

ident                         :: Parser String
ident                         =  do x  <- lower
                                    xs <- many' (lower +++ upper)
                                    return (x:xs)

space :: Parser String
space = many' (sat isWhite)

isWhite :: Char -> Bool
isWhite ' ' = True
isWhite '\t' = True
isWhite '\r' = True
isWhite '\v' = True
isWhite _ = False

comment                       :: Parser ()
comment                       = do string "--"
                                   many' (sat (/= '\n'))
                                   return ()
token :: Parser a -> Parser a
token p = do {a <- p; space; return a}

apply :: Parser a -> String -> [(a,String)]
apply p = parse (do {space; p})

identifier                    :: Parser String
identifier                    =  token ident

symbol                        :: String -> Parser String
symbol xs                     =  token (string xs)

chainl :: Parser a -> Parser (a -> a -> a) -> a -> Parser a
chainl p op a = (p `chainl1` op) +++ return a

chainl1 :: Parser a -> Parser (a -> a -> a) -> Parser a
p `chainl1` op = do {a <- p; rest a}
                 where
                    rest a = (do f <- op
                                 b <- p
                                 rest (f a b))
                            +++ return a

expr :: (M.Map String Float) -> Parser Float
addop :: Parser (Float -> Float -> Float)
mulop :: Parser (Float -> Float -> Float)

expr m = token (term m) `chainl1` (token addop)
term m = token (powRule m) `chainl1` (token mulop)
powRule m = do f <- token (factor m)
               (do char '^'
                   t <- token (powRule m)
                   return (f ** t)) +++ return f
                 
factor m = float +++  
           (do 
              id <- identifier
              let val = M.lookup id m
              case val of 
                   Nothing -> failure
                   Just var -> return var) +++ -- ids 
           (do {token (symb "("); n <- token (expr m); token (symb ")"); return n}) 

addop = do {symb "+"; return (+)} +++ do {symb "-"; return (-)}
mulop = do {symb "*"; return (*)} +++ do {symb "/"; return (/)}

insertVar :: (M.Map String Float) -> Parser (M.Map String Float)
insertVar m = do
              id <- token identifier
              token (symb "=")
              e <- token (expr (m))
              return (M.insert id e m)

insertVars :: (M.Map String Float) -> Parser (M.Map String Float)
insertVars m = do {a <- insertVar m; rest a}
                 where
                    rest a = (do token (symb "\n")
                                 b <- insertVar a 
                                 rest b)
                            +++ return a

equations :: Parser Float
equations = do
              map <- insertVars (M.empty)
              token (symb "\n")
              expr map

eval :: String -> Float
eval xs = fst (head (parse (expr M.empty) xs))















