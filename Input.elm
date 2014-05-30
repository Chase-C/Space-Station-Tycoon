module Input where

import Dict     as D
import Keyboard as K
import Char     as C

import Types (..)

modalKeymap : D.Dict C.KeyCode Modal
modalKeymap = D.fromList
  [ (C.toCode 'b', Build)
  , (32,           Pause) -- Space
  , (13,           Enter) -- Enter
  , (27,           Exit)  -- Escape
  ]

modes : Signal Input
modes =
    let keys = map (\(kc, modal) -> lift ((\a b -> a) modal) . keepIf id True <| K.isDown kc) <| D.toList modalKeymap
    in  Modal <~ merges keys

cursor : Signal Input
cursor =
    let dir  = placeInTuple <~ K.arrows
        hjkl = placeInTuple <~ K.directions (C.toCode 'k') (C.toCode 'j') (C.toCode 'h') (C.toCode 'l')
    in  shiftJump <~ merges [ Cursor <~ dir
                            , Cursor <~ hjkl
                            ]
                   ~ K.shift

placeInTuple : { x:Int, y:Int } -> (Int, Int)
placeInTuple input = (input.x, input.y)

shiftJump : Input -> Bool -> Input
shiftJump input shift =
    if shift == True
      then case input of
             Cursor (x, y) -> Cursor (x * 10, y * 10)
             _             -> input
      else input

timeStep : Signal Input
timeStep = TimeStep <~ fps 2

input : Signal Input
input = merges [cursor, modes, timeStep]
