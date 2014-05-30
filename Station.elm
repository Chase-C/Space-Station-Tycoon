module Station where

import Window
import Graphics.Collage
import Dict     as D
import Keyboard as K

import Types (..)

defaultStation = { tiles = tileRect Floor (-3, -3) (3, 3) }

tileRect : Tile -> (Int, Int) -> (Int, Int) -> D.Dict (Float, Float) Tile
tileRect tileType (x1, y1) (x2, y2) =
    let (lx, ux) = if x1 > x2 then (x2, x1) else (x1, x2)
        (ly, uy) = if y1 > y2 then (y2, y1) else (y1, y2)
    in   D.fromList <| foldl (\xp tiles -> concat 
                       [ map (\yp -> ((toFloat xp, toFloat yp), tileType)) [ly..uy]
                       , tiles ])
                     [] [lx..ux]

addToStation : Station -> Cursor -> Station
addToStation station cursor =
    case cursor of
      Position _      -> station
      Selection p1 p2 -> { station | tiles <- D.union station.tiles <| tileRect Floor p1 p2 }
          

drawTile : ((Float, Float), Tile) -> Form
drawTile ((x, y), tile) = rect 16 16 |> filled (rgb 0 255 128) |> move (x * 16, y * 16)

drawStation : Station -> Form
drawStation station = group <| map drawTile <| D.toList station.tiles
