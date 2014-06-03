module Main where

import Window
import Graphics.Collage
import Dict     as D
import Keyboard as K
import Text     as T
import Debug (log)

import Types     (..)
import Input     (..)
import Step      (..)
import Cursor    (..)
import Inventory (..)
import Building  (..)
import Station   (..)

defaultGame : GameState
defaultGame = { gameTime      = 0
              , gameCursor    = defaultCursor
              , gameMode      = Playing::[]
              , gameStation   = defaultStation
              , gameInv       = defaultInventory
              }

draw : (Int, Int) -> GameState -> Element
draw (w, h) gs =
    let (gw, gh) = (w - 256 - 24, h - 16)
        mode     = head gs.gameMode
    in  beside (
          color (rgb 32 32 32) <|
          container (gw + 12) h (topLeftAt (absolute 8) (absolute 8)) <|
          collage gw gh
            <| filled (rgb 0 0 0) (rect (toFloat gw) (toFloat gh))
            :: drawStation gs.gameStation
            :: case mode of
                 Building _ -> drawCursor gs.gameCursor gs.gameTime :: []
                 _          -> []
        ) (
          color (rgb 32 32 32) <|
          container (w - (gw + 12)) h (topRightAt (absolute 8) (absolute 8)) <|
          layers <| (color black <| spacer 256 gh) :: (
          flow down <| (map (leftAligned . T.color white)
            [ toText <| modeString mode
            , toText <| "Credits: " ++   show gs.gameInv.credits
            , toText <| "Ore:       " ++ show gs.gameInv.ore
            ]) ++
              case mode of
                Building _ -> [buildElement buildDict 2]
                _          -> []
          ) :: []
        )

modeString : Mode -> String
modeString mode =
    case mode of
      Building _ -> "Building"
      Paused     -> "Paused"
      Playing    -> "Playing"

gameState = foldp step defaultGame input

main = draw <~ Window.dimensions ~ gameState
