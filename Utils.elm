module Utils where

import String (cons)
import Char   (fromCode)

letterPrefixes : [String]
letterPrefixes =
    map (\c -> cons '(' <| cons (fromCode c) ") ") [97..122]
