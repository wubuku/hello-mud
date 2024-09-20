// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../systems/ItemIdQuantityPair.sol";
import "./SortedVectorUtil.sol";
import { COPPER_ORE, NORMAL_LOGS, COTTONS } from "./ItemIds.sol";

library ShipUtil {
  uint32 internal constant DEFAULT_SHIP_HEALTH_POINTS = 20;

  function calculateShipAttributes(
    ItemIdQuantityPair[] memory buildingExpenses
  ) internal pure returns (uint32, uint32, uint32, uint32) {
    uint32 copperOreQuantity = SortedVectorUtil.getItemIdQuantityPairOrRevert(buildingExpenses, COPPER_ORE).quantity;
    uint32 normalLogQuantity = SortedVectorUtil.getItemIdQuantityPairOrRevert(buildingExpenses, NORMAL_LOGS).quantity;
    uint32 cottonsQuantity = SortedVectorUtil.getItemIdQuantityPairOrRevert(buildingExpenses, COTTONS).quantity;

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
}
