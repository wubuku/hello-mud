// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { IslandResourcesGathered } from "./MapEvents.sol";
import { MapData, MapLocation, MapLocationData } from "../codegen/index.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";
import { MapLocationType } from "./MapLocationType.sol";
import { TsRandomUtil } from "../utils/TsRandomUtil.sol";
import { ItemIds, RESOURCE_TYPE_MINING, RESOURCE_TYPE_WOODCUTTING, COTTON_SEEDS } from "../utils/ItemIds.sol";
import { MapUtil } from "../utils/MapUtil.sol";

library MapGatherIslandResourcesLogic {
  error ResourceNotRegeneratedYet();
  error IslandNotOccupied(uint32 x, uint32 y);
  error PlayerIsNotIslandOwner(uint256 playerId, uint32 x, uint32 y);

  function verify(
    uint256 playerId,
    uint32 coordinatesX,
    uint32 coordinatesY,
    MapData memory mapData
  ) internal view returns (IslandResourcesGathered memory) {
    //assertPlayerIsIslandOwner(playerId, coordinatesX, coordinatesY);
    MapLocationData memory location = MapLocation.get(coordinatesX, coordinatesY);
    if (location.occupiedBy == uint256(0)) revert IslandNotOccupied(coordinatesX, coordinatesY);
    if (location.occupiedBy != playerId) revert PlayerIsNotIslandOwner(playerId, coordinatesX, coordinatesY);
    if (
      location.resourcesItemIds.length > 0 && location.resourcesItemIds.length == location.resourcesQuantities.length
    ) {
      ItemIdQuantityPair[] memory resources = new ItemIdQuantityPair[](location.resourcesItemIds.length);
      for (uint i = 0; i < location.resourcesItemIds.length; i++) {
        resources[i] = ItemIdQuantityPair(location.resourcesItemIds[i], uint32(location.resourcesQuantities[i]));
      }
      return IslandResourcesGathered(playerId, location.gatheredAt, coordinatesX, coordinatesY, resources);
    } else {
      uint64 nowTime = uint64(block.timestamp);
      // MapUtil will check if the location exists and is an island
      uint32 resourcesQuantity = MapUtil.getIslandResourcesQuantityToGather(coordinatesX, coordinatesY, nowTime);
      if (resourcesQuantity == 0) revert ResourceNotRegeneratedYet();

      uint32[] memory resourceItemIds = new uint32[](3);
      resourceItemIds[0] = RESOURCE_TYPE_MINING;
      resourceItemIds[1] = RESOURCE_TYPE_WOODCUTTING;
      resourceItemIds[2] = COTTON_SEEDS;

      bytes memory randSeed = abi.encodePacked(coordinatesX, coordinatesY, playerId, nowTime);

      uint64[] memory randomResourceQuantities = TsRandomUtil.divideInt(randSeed, resourcesQuantity, 3);

      ItemIdQuantityPair[] memory resources = new ItemIdQuantityPair[](3);
      for (uint i = 0; i < 3; i++) {
        resources[i] = ItemIdQuantityPair(resourceItemIds[i], uint32(randomResourceQuantities[i]));
      }

      return IslandResourcesGathered(playerId, nowTime, coordinatesX, coordinatesY, resources);
    }
  }

  function mutate(
    IslandResourcesGathered memory islandResourcesGathered,
    MapData memory mapData
  ) internal returns (ItemIdQuantityPair[] memory, MapData memory) {
    uint32 coordinatesX = islandResourcesGathered.coordinatesX;
    uint32 coordinatesY = islandResourcesGathered.coordinatesY;

    // Clear resources and update gathered time
    MapLocation.setResourcesItemIds(coordinatesX, coordinatesY, new uint32[](0));
    MapLocation.setResourcesQuantities(coordinatesX, coordinatesY, new uint32[](0));
    MapLocation.setGatheredAt(coordinatesX, coordinatesY, islandResourcesGathered.gatheredAt);

    return (islandResourcesGathered.resources, mapData);
  }

  function assertPlayerIsIslandOwner(uint256 playerId, uint32 x, uint32 y) internal view {
    MapLocationData memory location = MapLocation.get(x, y);

    if (location.occupiedBy == uint256(0)) revert IslandNotOccupied(x, y);
    if (location.occupiedBy != playerId) revert PlayerIsNotIslandOwner(playerId, x, y);
  }
}
