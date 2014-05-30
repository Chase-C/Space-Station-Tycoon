module Main where

import Window
import Graphics.Collage
import Dict     as D
import Keyboard as K
import Debug (log)

import Types   (..)
import Input   (..)
import Step    (..)
import Cursor  (..)
import Station (..)

tileRect : Int -> Int -> Int -> Int -> [((Float, Float), Tile)]
tileRect x y w h = foldl (\xp tiles -> concat 
                     [ map (\yp -> ((toFloat xp, toFloat yp), {tileType = 1})) [y..(y+h-1)]
                     , tiles ])
                   [] [x..(x+w-1)]

defaultGame : GameState
defaultGame = { gameSize    = (1280, 720)
              , gameTime    = 0
              , gameCursor  = defaultCursor
              , gameMode    = Playing::[]
              , gameStation = defaultStation
              }

draw : (Int, Int) -> GameState -> Element
draw (w, h) gs =
    let (gw, gh) = gs.gameSize
        mode     = head gs.gameMode
    in  color (rgb 32 32 32) <|
        container w h middle <|
        collage gw gh
          <| filled (rgb 0 0 0) (rect (toFloat gw) (toFloat gh))
          :: drawStation gs.gameStation
          :: printMode mode gw gh
          :: if | mode == Building -> drawCursor gs.gameCursor gs.gameTime :: []
                | otherwise        -> []

printMode : Mode -> Int -> Int -> Form
printMode mode w h =
    let text = case mode of
                 Building -> "Building"
                 Paused   -> "Paused"
                 _        -> ""
    in  plainText text |> color (rgb 128 128 128)
                       |> toForm
                       |> move (0, (toFloat h / 2) - 8)

gameState = foldp step defaultGame input

main = draw <~ Window.dimensions ~ gameState
