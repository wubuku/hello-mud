// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { IslandResourcesGathered } from "./MapEvents.sol";
import { MapData } from "../codegen/index.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";

library MapGatherIslandResourcesLogic {
  function verify(
    uint256 playerId,
    int32 coordinatesX,
    int32 coordinatesY,
    MapData memory mapData
  ) internal pure returns (IslandResourcesGathered memory) {
    // TODO ...
    //return IslandResourcesGathered(...);
  }

  function mutate(
    IslandResourcesGathered memory islandResourcesGathered,
    MapData memory mapData
  ) internal pure returns (ItemIdQuantityPair[] memory, MapData memory) {
    // TODO ...
  }
}
