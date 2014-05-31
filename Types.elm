module Types where

import Array (Array)

---------------- Input ----------------

data Input = TimeStep Time
           | Cursor (Int, Int)
           | Modal Modal

data Modal = Pause
           | Build
           | Enter
           | Exit

---------------- Game Objects ----------------

data Tile = Floor
          | Wall
          | Door
          | Empty

type Station = { tiles : Array2D Tile
               , form  : Form
               }

---------------- Game State ----------------

data Mode = Playing | Paused | Building

data Cursor = Position  (Int, Int)
            | Selection (Int, Int) (Int, Int)

type GameState = { gameTime    : Time
                 , gameCursor  : Cursor
                 , gameMode    : [Mode] -- Used as a stack
                 , gameStation : Station
                 }

---------------- Util Objects ----------------

type Array2D a = { width  : Int
                 , height : Int
                 , array  : Array (Array a)
                 }
