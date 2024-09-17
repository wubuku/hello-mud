// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { MapIslandClaimed } from "./MapEvents.sol";
import { MapData, MapLocation } from "../codegen/index.sol";
import { SortedVectorUtil } from "../utils/SortedVectorUtil.sol";
import { MapLocationType } from "./MapLocationType.sol";

library MapClaimIslandLogic {
  error ELocationNotFound();
  error ELocationTypeMismatch();
  error EIslandAlreadyClaimed();

  function verify(
    uint32 coordinatesX,
    uint32 coordinatesY,
    uint256 claimedBy,
    uint64 claimedAt,
    MapData memory mapData
  ) internal view returns (MapIslandClaimed memory) {
    if (!MapLocation.getExisting(coordinatesX, coordinatesY)) {
      revert ELocationNotFound();
    }

    uint32 locationType = MapLocation.getType_(coordinatesX, coordinatesY);
    if (locationType != MapLocationType.ISLAND) {
      revert ELocationTypeMismatch();
    }

    address occupiedBy = MapLocation.getOccupiedBy(coordinatesX, coordinatesY);
    if (occupiedBy != address(0)) {
      revert EIslandAlreadyClaimed();
    }

    return MapIslandClaimed(coordinatesX, coordinatesY, claimedBy, claimedAt);
  }

  function mutate(MapIslandClaimed memory mapIslandClaimed, MapData memory mapData) internal returns (MapData memory) {
    uint32 coordinatesX = mapIslandClaimed.coordinatesX;
    uint32 coordinatesY = mapIslandClaimed.coordinatesY;

    // Set the island as occupied
    MapLocation.setOccupiedBy(coordinatesX, coordinatesY, address(uint160(mapIslandClaimed.claimedBy)));

    // Remove all resources from the island
    uint32[] memory emptyArray = new uint32[](0);
    MapLocation.setResourcesItemIds(coordinatesX, coordinatesY, emptyArray);
    MapLocation.setResourcesQuantities(coordinatesX, coordinatesY, emptyArray);

    // Set the gathered_at timestamp
    MapLocation.setGatheredAt(coordinatesX, coordinatesY, mapIslandClaimed.claimedAt);

    // Note: We don't need to update mapData here as MapLocation directly modifies the state

    return mapData;
  }
}
