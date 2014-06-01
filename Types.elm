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

---------------- Player Objects ----------------

type Inventory = { credits : Int
                 , ore     : Int
                 }

---------------- Game State ----------------

data Mode = Playing | Paused | Building

data Cursor = Position  (Int, Int)            Color
            | Selection (Int, Int) (Int, Int) Color

type GameState = { gameTime      : Time
                 , gameCursor    : Cursor
                 , gameMode      : [Mode] -- Used as a stack
                 , gameStation   : Station
                 , gameInv       : Inventory
                 }

---------------- Util Objects ----------------

type Array2D a = { width  : Int
                 , height : Int
                 , array  : Array (Array a)
                 }
