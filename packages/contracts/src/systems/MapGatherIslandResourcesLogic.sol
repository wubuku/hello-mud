// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { console } from "forge-std/console.sol";
import { IslandResourcesGathered } from "./MapEvents.sol";
import { Map, MapData, MapLocation, MapLocationData } from "../codegen/index.sol";
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
    assertPlayerIsIslandOwner(playerId, coordinatesX, coordinatesY);

    uint64 nowTime = uint64(block.timestamp);

    // MapUtil will check if the location exists and is an island
    uint32 resourcesQuantity = MapUtil.getIslandResourcesQuantityToGather(coordinatesX, coordinatesY, nowTime);
    if (resourcesQuantity == 0) revert ResourceNotRegeneratedYet();

    bytes memory randSeed = abi.encodePacked(coordinatesX, coordinatesY, playerId, nowTime);

    uint64[] memory randomResourceQuantities = TsRandomUtil.divideInt(
      randSeed,
      resourcesQuantity,
      uint64(mapData.islandRenewableItemIds.length)
    );
    // for (uint i = 0; i < randomResourceQuantities.length; i++) {
    //   console.log("RandomResourceQuantities[%d] = %d", i, randomResourceQuantities[i]);
    // }
    ItemIdQuantityPair[] memory resources = new ItemIdQuantityPair[](mapData.islandRenewableItemIds.length);
    for (uint i = 0; i < mapData.islandRenewableItemIds.length; i++) {
      resources[i] = ItemIdQuantityPair(mapData.islandRenewableItemIds[i], uint32(randomResourceQuantities[i]));
    }
    return IslandResourcesGathered(playerId, nowTime, coordinatesX, coordinatesY, resources);
  }

  function mutate(
    IslandResourcesGathered memory islandResourcesGathered,
    MapData memory mapData
  ) internal returns (ItemIdQuantityPair[] memory, MapData memory) {
    uint32 coordinatesX = islandResourcesGathered.coordinatesX;
    uint32 coordinatesY = islandResourcesGathered.coordinatesY;
    // uint32[] memory resouceItemIds = new uint32[](islandResourcesGathered.resources.length);
    // uint32[] memory resourcesQuantities = new uint32[](islandResourcesGathered.resources.length);
    // for (uint i = 0; i < islandResourcesGathered.resources.length; i++) {
    //   resouceItemIds[i] = islandResourcesGathered.resources[i].itemId;
    //   resourcesQuantities[i] = islandResourcesGathered.resources[i].quantity;
    // }
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
