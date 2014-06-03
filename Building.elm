module Building where

import Graphics.Element as E
import Text             as T
import Dict             as D
import Char (toCode)

import Types (..)
import Tile  (tileString)
import Utils (letterPrefixes)

buildDict : BuildDict
buildDict = D.fromList
    <| (toCode 'a', Floor)
    :: (toCode 'b', Wall)
    :: (toCode 'c', Door)
    :: (toCode 'd', Empty)
    :: []

buildElement : BuildDict -> Int -> Element
buildElement dict code =
    flow down <|
      zipWith (tileElement code) (D.toList dict) letterPrefixes

tileElement : Int -> (Int, Tile) -> String -> Element
tileElement code (c, tile) prefix =
    let color = if c == code
                  then rgb 128 255 128
                  else rgb 255 255 255
    in  leftAligned . T.color color <| toText <| prefix ++ tileString tile
