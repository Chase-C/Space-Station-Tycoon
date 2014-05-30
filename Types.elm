module Types where

import Dict (Dict)

---------------- Input ----------------

data Input = TimeStep Time
           | Cursor (Int, Int)
           | Modal Modal

data Modal = Pause
           | Build
           | Enter
           | Exit

---------------- Game Objects ----------------

type Tile    = { tileType : Int }
type Station = { tiles : Dict (Float, Float) Tile }

---------------- Game State ----------------

data Mode = Playing | Paused | Building

data Cursor = Position  (Int, Int)
            | Selection (Int, Int) (Int, Int)

type GameState = { gameTime    : Time
                 , gameCursor  : Cursor
                 , gameMode    : [Mode] -- Used as a stack
                 , gameStation : Station
                 }
