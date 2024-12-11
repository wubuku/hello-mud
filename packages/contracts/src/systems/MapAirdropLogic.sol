// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { IslandResourcesAirdropped } from "./MapEvents.sol";
import { MapData } from "../codegen/index.sol";
import { MapLocation } from "../codegen/index.sol";
import { MapLocationType } from "./MapLocationType.sol";

//import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";
//import { MapLocationData } from "../codegen/index.sol";
//import { MapLocation } from "../codegen/index.sol";
// You may need to use the MapLocation library to access and modify the state (MapLocationData) of the MapLocation entity within the Map aggregate

/**
 * @title MapAirdropLogic Library
 * @dev Implements the Map.Airdrop method.
 */
library MapAirdropLogic {
  error ELocationNotFound();
  error ELocationTypeMismatch();

  /**
   * @notice Verifies the Map.Airdrop command.
   * @param mapData The current state the Map.
   * @return A IslandResourcesAirdropped event struct.
   */
  function verify(
    uint32 coordinatesX,
    uint32 coordinatesY,
    uint32[] memory resourcesItemIds,
    uint32[] memory resourcesQuantities,
    MapData memory mapData
  ) internal view returns (IslandResourcesAirdropped memory) {
    // Check if location exists and is an island
    if (!MapLocation.getExisting(coordinatesX, coordinatesY)) {
      revert ELocationNotFound();
    }

    uint32 locationType = MapLocation.getType_(coordinatesX, coordinatesY);
    if (locationType != MapLocationType.ISLAND) {
      revert ELocationTypeMismatch();
    }

    // Verify arrays have same length
    require(resourcesItemIds.length == resourcesQuantities.length, "Arrays length mismatch");

    return
      IslandResourcesAirdropped({
        coordinatesX: coordinatesX,
        coordinatesY: coordinatesY,
        resourcesItemIds: resourcesItemIds,
        resourcesQuantities: resourcesQuantities
      });
  }

  /**
   * @notice Performs the state mutation operation of Map.Airdrop method.
   * @dev This function is called after verification to update the Map's state.
   * @param islandResourcesAirdropped The IslandResourcesAirdropped event struct from the verify function.
   * @param mapData The current state of the Map.
   * @return The new state of the Map.
   */
  function mutate(
    IslandResourcesAirdropped memory islandResourcesAirdropped,
    MapData memory mapData
  ) internal returns (MapData memory) {
    uint32 coordinatesX = islandResourcesAirdropped.coordinatesX;
    uint32 coordinatesY = islandResourcesAirdropped.coordinatesY;

    // Update the resources on the island
    MapLocation.setResourcesItemIds(coordinatesX, coordinatesY, islandResourcesAirdropped.resourcesItemIds);
    MapLocation.setResourcesQuantities(coordinatesX, coordinatesY, islandResourcesAirdropped.resourcesQuantities);

    return mapData;
  }
}
