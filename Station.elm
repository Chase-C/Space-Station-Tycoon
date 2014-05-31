module Station where

import Window
import Graphics.Collage
import Array2D  as A
import Keyboard as K

import Types (..)

--defaultTiles = A.setRect (0, 0) (7, 7) Floor <| A.createFilled 64 64 Empty
defaultTiles = A.filled 48 48 Empty
defaultStation = { tiles = defaultTiles
                 , form  = drawTiles defaultTiles
                 }

addToStation : Station -> Cursor -> Station
addToStation station cursor =
    case cursor of
      Position _      -> station
      Selection p1 p2 -> let newTiles = A.setRect p1 p2 Floor station.tiles
                         in  { tiles = newTiles
                             , form  = drawTiles newTiles
                             }

drawTile : (Int, Int) -> (Int, Int) -> Tile -> Form
drawTile (w, h) (x, y) tile =
    rect 16 16 |> filled
        (case tile of
          Floor -> (rgb 0   255 128)
          Wall  -> (rgb 0   128 255)
          Door  -> (rgb 128 128 128)
          Empty -> (rgb 64  64  64 ))
    |> move (toFloat (x - w) * 16, toFloat (y - h) * 16)

drawTiles : Array2D Tile -> Form
drawTiles arr = group <| A.toList
                      <| A.indexedMap (drawTile (div arr.width 2, div arr.height 2)) arr

drawStation : Station -> Form
drawStation station = station.form
