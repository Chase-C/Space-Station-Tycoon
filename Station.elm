module Station where

import Window
import Graphics.Collage
import Array2D  as A
import Keyboard as K

import Types (..)
import Tile  (tileToForm)

--defaultTiles = A.setRect (0, 0) (7, 7) Floor <| A.createFilled 64 64 Empty
defaultTiles = A.set (4, 0) Door
                 <| A.setRect (-3, -3) (3, 3) Floor
                 <| A.setRect (-4, -4) (4, 4) Wall
                 <| A.filled 64 48 Empty
defaultStation = { tiles = defaultTiles
                 , form  = drawTiles defaultTiles
                 }

addToStation : Station -> Cursor -> Station
addToStation station cursor =
    case cursor of
      Position _      _ -> station
      Selection p1 p2 _ -> let newTiles = A.setRect p1 p2 Floor station.tiles
                           in  { tiles = newTiles
                               , form  = drawTiles newTiles
                               }

drawTile : (Int, Int) -> (Int, Int) -> Tile -> Form
drawTile (w, h) (x, y) tile =
    tileToForm tile |> move (toFloat (x - w) * 16, toFloat (y - h) * 16)

drawTiles : Array2D Tile -> Form
drawTiles arr = group <| A.toList
                      <| A.indexedMap (drawTile (div arr.width 2, div arr.height 2)) arr

drawStation : Station -> Form
drawStation station = station.form
