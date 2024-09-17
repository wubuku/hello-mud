// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../systems/ShipInventoryLib.sol";
import "../systems/ItemIdQuantityPair.sol";
import { ShipData, ShipInventoryData } from "../codegen/index.sol";

library LootUtil {
  error BuildingExpensesLengthMismatch(uint256 itemIdsLength, uint256 quantitiesLength);

  function calculateLoot(
    uint256 shipId,
    ShipData memory ship
  ) internal view returns (uint32[] memory itemIds, uint32[] memory itemQuantities) {
    ShipInventoryData[] memory inventory = ShipInventoryLib.getAllInventory_(shipId);

    if (ship.buildingExpensesItemIds.length != ship.buildingExpensesQuantities.length) {
      revert BuildingExpensesLengthMismatch(
        ship.buildingExpensesItemIds.length,
        ship.buildingExpensesQuantities.length
      );
    }

    uint256 totalItems = inventory.length + ship.buildingExpensesItemIds.length;
    itemIds = new uint32[](totalItems);
    itemQuantities = new uint32[](totalItems);

    uint256 index = 0;

    // Process ship inventory
    for (uint256 i = 0; i < inventory.length; i++) {
      if (inventory[i].inventoryQuantity > 0) {
        itemIds[index] = inventory[i].inventoryItemId;
        itemQuantities[index] = inventory[i].inventoryQuantity;
        index++;
      }
    }

    // Process building expenses
    for (uint256 i = 0; i < ship.buildingExpensesItemIds.length; i++) {
      uint32 quantity = (ship.buildingExpensesQuantities[i] * 4) / 5;
      if (quantity > 0) {
        itemIds[index] = ship.buildingExpensesItemIds[i];
        itemQuantities[index] = quantity;
        index++;
      }
    }

    // Resize arrays to remove unused slots
    assembly {
      mstore(itemIds, index)
      mstore(itemQuantities, index)
    }
  }
}
