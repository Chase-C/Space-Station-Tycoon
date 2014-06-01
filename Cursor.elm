module Cursor where

import Window
import Graphics.Collage
import Dict     as D
import Keyboard as K
import Debug (..)

import Types (..)

defaultCursor : Cursor
defaultCursor = Position (0, 0) <| rgb 128 128 128

enterCursor : Cursor -> Cursor
enterCursor cursor =
    case cursor of
      Position    (x, y) c -> Selection (x, y) (x, y) c
      Selection _ (x, y) c -> Position  (x, y)        c

drawCursor : Cursor -> Time -> Form
drawCursor cursor t =
    let (cx, cy, sx, sy, w, h, blink, color) =
        case cursor of
          Position  (x, y) c -> let (tx, ty) = (toFloat x * 16, toFloat y * 16)
                                in  (tx, ty, tx, ty, toFloat 16, toFloat 16, True, c)
          Selection (x1, y1) (x2, y2) c ->
              ( toFloat x2 * 16
              , toFloat y2 * 16
              , toFloat <| (*) 16 <| if x1 > x2 then x2 else x1
              , toFloat <| (*) 16 <| if y1 > y2 then y2 else y1
              , toFloat <| (*) 16 <| (abs <| x1 - x2) + 1
              , toFloat <| (*) 16 <| (abs <| y1 - y2) + 1
              , False, c
              )
    in
        -- The inner, translucent rectangle
        (if (not blink) || ((round <| inSeconds t * 2) `mod` 2) == 1
              then [rect w h |> filled color
                             |> alpha 0.5
                             |> move (sx + (w / 2) - 8, sy + (h / 2) - 8)]
              else [])
        -- The border rectangle
        ++ [rect 16 16 |> outlined (solid <| rgb 64 64 255) |> move (cx, cy)]
        |> group-- |> move (sx, sy)
