// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { IslandAdded } from "./MapEvents.sol";
import { MapData } from "../codegen/index.sol";
import { MapLocation } from "../codegen/tables/MapLocation.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";
import { MapLocationType } from "./MapLocationType.sol";

library MapAddIslandLogic {
  error ELocationAlreadyExists();

  function verify(
    uint32 coordinatesX,
    uint32 coordinatesY,
    ItemIdQuantityPair[] memory resources,
    MapData memory mapData
  ) internal view returns (IslandAdded memory) {
    // Check if the location already exists
    if (MapLocation.getExisting(coordinatesX, coordinatesY)) {
      revert ELocationAlreadyExists();
    }

    // Create and return the IslandAdded event
    return IslandAdded(coordinatesX, coordinatesY, resources);
  }

  function mutate(
    IslandAdded memory islandAdded,
    MapData memory mapData
  ) internal returns (MapData memory) {
    uint32 coordinatesX = islandAdded.coordinatesX;
    uint32 coordinatesY = islandAdded.coordinatesY;

    // Create a new island location
    MapLocation.setExisting(coordinatesX, coordinatesY, true);
    MapLocation.setType_(coordinatesX, coordinatesY, MapLocationType.ISLAND);
    MapLocation.setOccupiedBy(coordinatesX, coordinatesY, address(0)); // Not occupied initially

    // Set the resources for the island
    uint32[] memory itemIds = new uint32[](islandAdded.resources.length);
    uint32[] memory quantities = new uint32[](islandAdded.resources.length);
    for (uint i = 0; i < islandAdded.resources.length; i++) {
      itemIds[i] = islandAdded.resources[i].itemId;
      quantities[i] = islandAdded.resources[i].quantity;
    }
    MapLocation.setResourcesItemIds(coordinatesX, coordinatesY, itemIds);
    MapLocation.setResourcesQuantities(coordinatesX, coordinatesY, quantities);
    MapLocation.setExisting(coordinatesX, coordinatesY, true);
    // Set initial gathered_at to 0
    MapLocation.setGatheredAt(coordinatesX, coordinatesY, 0);

    // Update the map data if necessary
    // For example, you might want to increase the island count or update the map boundaries
    // mapData.islandCount++;
    // mapData.width = max(mapData.width, coordinatesX + 1);
    // mapData.height = max(mapData.height, coordinatesY + 1);

    return mapData;
  }
}
