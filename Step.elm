module Step where

import Window
import Graphics.Collage
import Dict     as D
import Keyboard as K

import Types     (..)
import Cursor    (..)
import Inventory (removeOre)
import Station   (addToStation)

step : Input -> GameState -> GameState
step input gameState =
    gameState |> case input of
                   TimeStep time -> stepGame time
                   Cursor (x, y) -> updateCursor x y
                   Modal modal   -> updateMode modal

---------------- Time Step ----------------

stepGame : Time -> GameState -> GameState
stepGame time gs =
    case head gs.gameMode of
      Playing -> { gs | gameTime <- gs.gameTime + time }
      _       -> { gs | gameTime <- gs.gameTime + time }

---------------- Cursor Update ----------------

updateCursor : Int -> Int -> GameState -> GameState
updateCursor x y gameState =
    case head gameState.gameMode of
      Building _ -> case gameState.gameCursor of
                    Position (cx, cy) _ ->
                        { gameState | gameCursor <- Position (cx + x, cy + y)
                                                      <| rgb 128 128 128 }
                    Selection (ex, ey) (cx, cy) _ ->
                        let col = if (abs (ex - cx) + 1) * (abs (ey - cy) + 1) > gameState.gameInv.ore
                                    then rgb 222 128 128
                                    else rgb 128 128 128
                        in  { gameState | gameCursor <- Selection (ex, ey) (cx + x, cy + y) col }
      _        -> gameState

---------------- Mode Switching ----------------

updateMode : Modal -> GameState -> GameState
updateMode modal gameState =
    gameState |> case modal of
                   Pause -> pause
                   Build -> build
                   Enter -> enter
                   Exit  -> exit

pause : GameState -> GameState
pause gs =
    case head gs.gameMode of
      Playing -> { gs | gameMode <- Paused::gs.gameMode }
      Paused  -> { gs | gameMode <- tail gs.gameMode }
      _       -> gs

build : GameState -> GameState
build gs =
    case head gs.gameMode of
      Building _ -> gs
      _          -> { gs | gameMode   <- (Building Floor)::gs.gameMode
                         , gameCursor <- defaultCursor }

enter : GameState -> GameState
enter gs =
    case head gs.gameMode of
      Building _ ->
          case gs.gameCursor of
            Position _ _ ->
                { gs | gameCursor <- enterCursor gs.gameCursor }
            Selection (x1, y1) (x2, y2) _ ->
                let area = (abs (x1 - x2) + 1) * (abs (y1 - y2) + 1)
                in  if area > gs.gameInv.ore
                      then { gs | gameCursor <- Position (x2, y2) <| rgb 128 128 128 }
                      else { gs | gameCursor  <- enterCursor gs.gameCursor
                                , gameStation <- addToStation gs.gameStation gs.gameCursor
                                , gameInv     <- removeOre gs.gameInv area }
      _        -> gs

exit : GameState -> GameState
exit gs =
    case head gs.gameMode of
      Playing    -> gs
      Building _ -> case gs.gameCursor of
                      Position  _ _   -> { gs | gameMode <- tail gs.gameMode }
                      Selection _ p _ -> { gs | gameCursor <- Position p <| rgb 128 128 128 }
      _          -> { gs | gameMode <- tail gs.gameMode }
