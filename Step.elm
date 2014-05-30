module Step where

import Window
import Graphics.Collage
import Dict     as D
import Keyboard as K

import Types   (..)
import Cursor  (..)
import Station (addToStation)

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
      Building -> case gameState.gameCursor of
                    Position (cx, cy) ->
                        { gameState | gameCursor <- Position (cx + x, cy + y) }
                    Selection p (cx, cy) ->
                        { gameState | gameCursor <- Selection p (cx + x, cy + y) }
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
      Building -> gs
      _        -> { gs | gameMode   <- Building::gs.gameMode
                       , gameCursor <- defaultCursor }

enter : GameState -> GameState
enter gs =
    case head gs.gameMode of
      Building -> case gs.gameCursor of
                    Position _ ->
                      { gs | gameCursor <- enterCursor gs.gameCursor }
                    Selection _ _ ->
                      { gs | gameCursor  <- enterCursor gs.gameCursor
                           , gameStation <- addToStation gs.gameStation gs.gameCursor }
      _        -> gs

exit : GameState -> GameState
exit gs =
    case head gs.gameMode of
      Playing -> gs
      _       -> { gs | gameMode <- tail gs.gameMode }
