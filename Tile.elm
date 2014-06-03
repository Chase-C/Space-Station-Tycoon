module Tile where

import Types (..)

tileToForm : Tile -> Form
tileToForm tile =
    rect 16 16 |> filled
        (case tile of
          Floor -> (rgb 0   255 128)
          Wall  -> (rgb 0   128 255)
          Door  -> (rgb 128 128 128)
          Empty -> (rgb 32  32  32 ))

tileString : Tile -> String
tileString tile =
    case tile of
      Floor -> "Floor"
      Wall  -> "Wall"
      Door  -> "Door"
      Empty -> "Empty"
