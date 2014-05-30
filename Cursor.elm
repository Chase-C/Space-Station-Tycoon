module Cursor where

import Window
import Graphics.Collage
import Dict     as D
import Keyboard as K
import Debug (..)

import Types (..)

defaultCursor : Cursor
defaultCursor = Position (0, 0)

enterCursor : Cursor -> Cursor
enterCursor cursor =
    case cursor of
      Position    (x, y) -> Selection (x, y) (x, y)
      Selection _ (x, y) -> Position  (x, y)

drawCursor : Cursor -> Time -> Form
drawCursor cursor t =
    let (cx, cy, sx, sy, w, h, blink) =
        case cursor of
          Position  (x, y) -> let (tx, ty) = (toFloat x * 16, toFloat y * 16)
                              in  (tx, ty, tx, ty, toFloat 16, toFloat 16, True)
          Selection (x1, y1) (x2, y2) ->
              ( toFloat x2 * 16
              , toFloat y2 * 16
              , toFloat <| (*) 16 <| if x1 > x2 then x2 else x1
              , toFloat <| (*) 16 <| if y1 > y2 then y2 else y1
              , toFloat <| (*) 16 <| (abs <| x1 - x2) + 1
              , toFloat <| (*) 16 <| (abs <| y1 - y2) + 1
              , False
              )
    in
        -- The inner, translucent rectangle
        (if (not blink) || ((round <| inSeconds t * 2) `mod` 2) == 1
              then [rect w h |> filled (rgb 128 128 128)
                             |> alpha 0.5
                             |> move (sx + (w / 2) - 8, sy + (h / 2) - 8)]
              else [])
        -- The border rectangle
        ++ [rect 16 16 |> outlined (solid <| rgb 64 64 255) |> move (cx, cy)]
        |> group-- |> move (sx, sy)
