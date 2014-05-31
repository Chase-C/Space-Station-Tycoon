module Array2D where

import Array as A
import List  as L
import Types (Array2D)

filled : Int -> Int -> a -> Array2D a
filled w h obj = { width  = w
                 , height = h
                 , array  = foldl (\_ oArr -> A.push
                                (foldl (\_ iArr -> A.push obj iArr) A.empty [1..h])
                            oArr) A.empty [1..w]
                 }

toList : Array2D a -> [a]
toList arr = concat <| L.map A.toList <| A.toList arr.array

width : Array2D a -> Int
width arr = arr.width

height : Array2D a -> Int
height arr = arr.height

get : (Int, Int) -> Array2D a -> Maybe a
get (x, y) arr =
    case A.get x arr.array of
      Nothing -> Nothing
      Just xa -> A.get y xa

set : (Int, Int) -> a -> Array2D a -> Array2D a
set (x, y) obj arr =
    case A.get x arr.array of
      Nothing -> arr
      Just xa -> let newArr = A.set x (A.set y obj xa) arr.array
                 in  { arr | array <- newArr }

setRect : (Int, Int) -> (Int, Int) -> a -> Array2D a -> Array2D a
setRect (x1, y1) (x2, y2) obj arr =
    let (lx, ux) = if x1 > x2 then (x2, x1) else (x1, x2)
        (ly, uy) = if y1 > y2 then (y2, y1) else (y1, y2)
    in  foldl (\xp oArr ->
            foldl (\yp iArr -> set (xp, yp) obj iArr) oArr [ly..uy]
        ) arr [lx..ux]

map : (a -> b) -> Array2D a -> Array2D b
map f arr = { arr | array <- A.map (A.map f) arr.array }

indexedMap : ((Int, Int) -> a -> b) -> Array2D a -> Array2D b
indexedMap f arr = 
    { arr | array <- A.indexedMap (\x ->
                       A.indexedMap (\y -> f (x, y))
                     ) arr.array }
