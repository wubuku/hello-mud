// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { System } from "@latticexyz/world/src/System.sol";
import { Map, MapData } from "../codegen/index.sol";
import { IslandAdded } from "./MapEvents.sol";
import { MapAddIslandLogic } from "./MapAddIslandLogic.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";

contract MapSystem is System {
  event IslandAddedEvent(int32 coordinatesX, int32 coordinatesY);

  function mapAddIsland(int32 coordinatesX, int32 coordinatesY, ItemIdQuantityPair[] memory resources) public {
    MapData memory mapData = Map.get();
    require(
      !(mapData.width == 0 && mapData.height == 0),
      "Map does not exist"
    );
    IslandAdded memory islandAdded = MapAddIslandLogic.verify(coordinatesX, coordinatesY, resources, mapData);
    emit IslandAddedEvent(islandAdded.coordinatesX, islandAdded.coordinatesY);
    MapData memory updatedMapData = MapAddIslandLogic.mutate(islandAdded, mapData);
    Map.set(updatedMapData);
  }

}
