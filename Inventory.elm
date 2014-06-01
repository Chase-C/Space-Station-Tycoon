module Inventory where

import Types (..)

defaultInventory : Inventory
defaultInventory = { credits = 100
                   , ore     = 50
                   }

removeOre : Inventory -> Int -> Inventory
removeOre inv num =
    let amount = max (inv.ore - num) 0
    in  { inv | ore <- amount }
