// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { console } from "forge-std/console.sol";
import { IslandResourcesGathered } from "./MapEvents.sol";
import { Map, MapData, MapLocation, MapLocationData, IslandRenewableItem } from "../codegen/index.sol";
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

    uint32 itemTotalQuantityWeight = 0;
    uint32[] memory itemQuantities = new uint32[](mapData.islandRenewableItemIds.length);

    // Calculate total weight
    for (uint i = 0; i < mapData.islandRenewableItemIds.length; i++) {
      uint32 itemId = mapData.islandRenewableItemIds[i];
      uint32 weight = IslandRenewableItem.getQuantityWeight(itemId);
      itemTotalQuantityWeight += weight;
      itemQuantities[i] = weight;
    }

    // Calculate quantities with rounding
    uint32 remainingQuantity = resourcesQuantity;
    for (uint i = 0; i < itemQuantities.length - 1; i++) {
      // Use multiplication before division to maintain precision
      uint32 quantity = uint32(
        (uint64(resourcesQuantity) * itemQuantities[i] + itemTotalQuantityWeight / 2) / itemTotalQuantityWeight
      );
      itemQuantities[i] = quantity;
      remainingQuantity -= quantity;
    }
    // Last item gets the remaining quantity to ensure total equals resourcesQuantity
    itemQuantities[itemQuantities.length - 1] = remainingQuantity;

    ItemIdQuantityPair[] memory resources = new ItemIdQuantityPair[](mapData.islandRenewableItemIds.length);
    for (uint i = 0; i < mapData.islandRenewableItemIds.length; i++) {
      resources[i] = ItemIdQuantityPair(mapData.islandRenewableItemIds[i], itemQuantities[i]);
    }
    return IslandResourcesGathered(playerId, nowTime, coordinatesX, coordinatesY, resources);
  }

  function mutate(
    IslandResourcesGathered memory islandResourcesGathered,
    MapData memory mapData
  ) internal returns (ItemIdQuantityPair[] memory, MapData memory) {
    uint32 coordinatesX = islandResourcesGathered.coordinatesX;
    uint32 coordinatesY = islandResourcesGathered.coordinatesY;
    uint32[] memory resouceItemIds = new uint32[](islandResourcesGathered.resources.length);
    uint32[] memory resourcesQuantities = new uint32[](islandResourcesGathered.resources.length);
    for (uint i = 0; i < islandResourcesGathered.resources.length; i++) {
      resouceItemIds[i] = islandResourcesGathered.resources[i].itemId;
      resourcesQuantities[i] = islandResourcesGathered.resources[i].quantity;
    }
    // Clear resources and update gathered time
    // 这里是将收集岛屿之后的资源重新设置为0，其实自从玩家占领岛屿时，是能看到岛屿有多少可收集的资源的，
    // 但是自动第一次收集完之后，从界面上看岛屿的可收集资源一直是0，因为并没有一个后台服务来更新岛屿的可收集资源（耗费gas）
    // 只能是超过一段时间之后，玩家可以收集资源时，合约根据 islandResourceRenewalQuantity 和权重重新计算可收集的资源
    // 也就是 islandResourcesGathered.resources
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
