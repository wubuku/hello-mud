// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { MapLocationData, MapLocation } from "../codegen/index.sol";
import { MapLocationType } from "../systems/MapLocationType.sol";

library MapUtil {
  error LocationNotFound();
  error LocationNotAnIsland();

  // Island resource regeneration time in seconds (1 day)
  uint256 constant ISLAND_RESOURCE_REGENERATION_TIME = 60 * 60 * 24;

  // Quantity of island resources regenerated
  uint32 constant ISLAND_RESOURCE_REGENERATION_QUANTITY = 600;

  /**
   * @notice Get the quantity of resources of the island to be gathered.
   * @param x The x-coordinate of the island.
   * @param y The y-coordinate of the island.
   * @param nowTime The current timestamp.
   * @return The quantity of resources that can be gathered.
   */
  function getIslandResourcesQuantityToGather(uint32 x, uint32 y, uint64 nowTime) internal view returns (uint32) {
    MapLocationData memory location = MapLocation.get(x, y);
    if (location.existing != true) {
      revert LocationNotFound();
    }

    if (location.type_ != MapLocationType.ISLAND) {
      revert LocationNotAnIsland();
    }

    uint64 elapsedTime = nowTime - location.gatheredAt;

    if (elapsedTime >= ISLAND_RESOURCE_REGENERATION_TIME) {
      return ISLAND_RESOURCE_REGENERATION_QUANTITY;
    } else {
      return 0;
    }
  }
}
