// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../systems/ItemIdQuantityPair.sol";
import "./SortedVectorUtil.sol";
import { COPPER_ORE, NORMAL_LOGS, COTTONS } from "./ItemIds.sol";

library ShipUtils {
  uint256 private constant NORMAL_LOGS_NOT_FOUND = 1;
  uint256 private constant COTTONS_NOT_FOUND = 2;
  uint256 private constant COPPER_ORES_NOT_FOUND = 3;
  uint256 private constant SHIP_ID_NOT_FOUND = 4;

  uint32 internal constant DEFAULT_SHIP_HEALTH_POINTS = 20;

  function calculateShipAttributes(
    ItemIdQuantityPair[] memory buildingExpenses
  ) internal pure returns (uint32, uint32, uint32, uint32) {
    uint32 copperOreQuantity = SortedVectorUtil
      .getItemIdQuantityPairOrRevert(buildingExpenses, COPPER_ORE, COPPER_ORES_NOT_FOUND)
      .quantity;
    uint32 normalLogQuantity = SortedVectorUtil
      .getItemIdQuantityPairOrRevert(buildingExpenses, NORMAL_LOGS, NORMAL_LOGS_NOT_FOUND)
      .quantity;
    uint32 cottonsQuantity = SortedVectorUtil
      .getItemIdQuantityPairOrRevert(buildingExpenses, COTTONS, COTTONS_NOT_FOUND)
      .quantity;

    return (DEFAULT_SHIP_HEALTH_POINTS, copperOreQuantity, normalLogQuantity, cottonsQuantity);
  }

  function calculateEnvironmentShipExperience(
    ItemIdQuantityPair[] memory buildingExpenses
  ) internal pure returns (uint32) {
    uint32 sum = 0;
    for (uint i = 0; i < buildingExpenses.length; i++) {
      sum += buildingExpenses[i].quantity;
    }

    if (sum >= 16) {
      return 6;
    } else if (sum >= 12) {
      return 3;
    } else if (sum >= 8) {
      return 2;
    } else {
      return 1;
    }
  }

  function removeShipId(uint256[] storage shipIds, uint256 shipId) internal {
    for (uint i = 0; i < shipIds.length; i++) {
      if (shipIds[i] == shipId) {
        shipIds[i] = shipIds[shipIds.length - 1];
        shipIds.pop();
        return;
      }
    }
    revert("Ship ID not found");
  }

  function findShipId(uint256[] memory shipIds, uint256 shipId) internal pure returns (uint256, bool) {
    for (uint i = 0; i < shipIds.length; i++) {
      if (shipIds[i] == shipId) {
        return (i, true);
      }
    }
    return (0, false);
  }
}
