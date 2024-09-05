// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { IslandAdded } from "./MapEvents.sol";
import { MapData } from "../codegen/index.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";

library MapAddIslandLogic {
  function verify(
    int32 coordinatesX,
    int32 coordinatesY,
    ItemIdQuantityPair[] memory resources,
    MapData memory mapData
  ) internal pure returns (IslandAdded memory) {
    // TODO ...
    //return IslandAdded(...);
  }

  function mutate(
    IslandAdded memory islandAdded,
    MapData memory mapData
  ) internal pure returns (MapData memory) {
    // TODO ...
  }
}
