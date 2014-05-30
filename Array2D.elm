module Array2D where

import Array as A
import Types (Array2D)

empty : Int -> Int -> Array2D a
empty w h = { width  = w
            , height = h
            , array  = A.empty
            }

fromList : Int -> Int -> [a] -> Array2D a
fromList w h xs = { width  = w
                  , height = h
                  , array  = A.fromList xs

toList : Array2D a -> [a]
toList arr = A.toList arr.array

width : Array2D a -> Int
width { width, _, _ } = width

height : Array2D a -> Int
height { _, height, _ } = height

get : (Int, Int) -> Array2D a -> Maybe a
get p { width, height, array } =
    let index = indexFromPair width height p
    in  A.get index array

set : (Int, Int) -> a -> Array2D a -> Array2D a
set (x, y) obj arr =
    let index = indexFromPair arr.width arr.height p
    in  { arr | array <- A.set index obj array }

setRect : (Int, Int) -> (Int, Int) -> a -> Array2D a -> Array2D a
setRect (x1, y1) (x2, y2) obj arr =
    let (lx, ux) = if x1 > x2 then (x2, x1) else (x1, x2)
        (ly, uy) = if y1 > y2 then (y2, y1) else (y1, y2)
    in  foldl (\xp oArr ->
                 foldl (\yp iArr -> set (xp, yp) obj iArr) oArr [ly..uy]
        ) arr [lx..ux]

map : (a -> b) -> Array2D a -> Array2D b
map f arr = { arr | array <- A.map f arr.array }

indexedMap : ((Int, Int) -> a -> b) -> Array2D a -> Array2D b
indexedMap f arr = 
    { arr | array <- A.indexedMap (\i -> f (pairFromIndex arr.width arr.height i)) arr.array }

indexFromPair : Int -> Int -> (Int, Int) -> Int
indexFromPair w _ (x, y) = x + (y * w)

pairFromIndex : Int -> Int -> Int -> (Int, Int)
pairFromIndex w _ i = (i `mod` w, i `div` w)
