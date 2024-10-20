// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { MultiIslandsAdded } from "./MapEvents.sol";
import { MapData } from "../codegen/index.sol";
import { Coordinates } from "./Coordinates.sol";
import { MapLocation } from "../codegen/tables/MapLocation.sol";
import { MapLocationType } from "./MapLocationType.sol";

/**
 * @title MapAddMultiIslandsLogic Library
 * @dev Implements the Map.AddMultiIslands method.
 */
library MapAddMultiIslandsLogic {
  error ELocationAlreadyExists(uint32 x, uint32 y);

  // LCG constants
  uint256 private constant a = 1664525;
  uint256 private constant c = 1013904223;
  uint256 private constant m = 2 ** 32;

  /**
   * @notice Verifies the Map.AddMultiIslands command.
   * @param coordinates Array of coordinates for new islands
   * @param resourceItemIds Resource item IDs for each island
   * @param resourceSubtotal Resource subtotal quantity of each island
   * @param mapData The current state of the Map.
   * @return A MultiIslandsAdded event struct.
   */
  function verify(
    Coordinates[] memory coordinates,
    uint32[] memory resourceItemIds,
    uint32 resourceSubtotal,
    MapData memory mapData
  ) internal view returns (MultiIslandsAdded memory) {
    // Check if any of the locations already exist
    // NOTE: move this to mutate for saving gas
    // for (uint i = 0; i < coordinates.length; i++) {
    //   if (MapLocation.getExisting(coordinates[i].x, coordinates[i].y)) {
    //     revert ELocationAlreadyExists(coordinates[i].x, coordinates[i].y);
    //   }
    // }

    // Create and return the MultiIslandsAdded event
    return MultiIslandsAdded(coordinates, resourceItemIds, resourceSubtotal);
  }

  /**
   * @notice Performs the state mutation operation of Map.AddMultiIslands method.
   * @dev This function is called after verification to update the Map's state.
   * @param multiIslandsAdded The MultiIslandsAdded event struct from the verify function.
   * @param mapData The current state of the Map.
   * @return The new state of the Map.
   */
  function mutate(
    MultiIslandsAdded memory multiIslandsAdded,
    MapData memory mapData
  ) internal returns (MapData memory) {
    uint32 resourceSubtotal = multiIslandsAdded.resourceSubtotal;
    uint32 islandCount = uint32(multiIslandsAdded.coordinates.length);
    uint32 resourceTypeCount = uint32(multiIslandsAdded.resourceItemIds.length);

    // 使用 uint256 来存储中间结果，避免溢出
    uint256 minResourceAmount = (uint256(resourceSubtotal) * 75) / 100 / resourceTypeCount;
    uint256 remainingForRandom = resourceSubtotal - (minResourceAmount * resourceTypeCount);

    // 生成初始随机种子
    uint256 randomSeed = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender)));

    for (uint i = 0; i < islandCount; i++) {
      uint32 x = multiIslandsAdded.coordinates[i].x;
      uint32 y = multiIslandsAdded.coordinates[i].y;

      if (MapLocation.getExisting(x, y)) {
        revert ELocationAlreadyExists(x, y);
      }

      // 创建新的岛屿位置
      MapLocation.setExisting(x, y, true);
      MapLocation.setType_(x, y, MapLocationType.ISLAND);
      MapLocation.setOccupiedBy(x, y, uint256(0)); // 初始未被占领
      MapLocation.setGatheredAt(x, y, 0);

      // 为岛屿设置资源
      uint32[] memory quantities = new uint32[](resourceTypeCount);
      uint256 localRemainingRandom = remainingForRandom;

      for (uint j = 0; j < resourceTypeCount; j++) {
        quantities[j] = uint32(minResourceAmount);

        if (j == resourceTypeCount - 1) {
          // 最后一种资源类型获得所有剩余的随机数量
          quantities[j] += uint32(localRemainingRandom);
        } else if (localRemainingRandom > 0) {
          // 使用 LCG 生成下一个伪随机数
          unchecked {
            randomSeed = (a * randomSeed + c) % m;
          }
          uint256 randomExtra = randomSeed % (localRemainingRandom + 1);

          quantities[j] += uint32(randomExtra);
          localRemainingRandom -= randomExtra;
        }
      }

      MapLocation.setResourcesItemIds(x, y, multiIslandsAdded.resourceItemIds);
      MapLocation.setResourcesQuantities(x, y, quantities);
    }

    return mapData;
  }
}
