// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ShipInventoryData } from "../codegen/index.sol";
import { ShipInventoryLib } from "../systems/ShipInventoryLib.sol";
import { ItemIdQuantityPair } from "../systems/ItemIdQuantityPair.sol";

library ShipInventoryUpdateUtil {
  error InsufficientItemQuantity(uint32 itemId, uint32 available, uint32 requested);

  function convertToItemIdQuantityPairs(
    ShipInventoryData[] memory inventory
  ) internal pure returns (ItemIdQuantityPair[] memory) {
    ItemIdQuantityPair[] memory pairs = new ItemIdQuantityPair[](inventory.length);
    for (uint i = 0; i < inventory.length; i++) {
      pairs[i] = ItemIdQuantityPair(inventory[i].inventoryItemId, inventory[i].inventoryQuantity);
    }
    return pairs;
  }

  function updateShipAllInventory(uint256 shipId, ItemIdQuantityPair[] memory newInventory) internal {
    // Remove all existing inventory
    uint64 currentCount = ShipInventoryLib.getInventoryCount(shipId);
    for (uint64 i = 0; i < currentCount; i++) {
      ShipInventoryLib.removeLastInventory(shipId);
    }

    // Add new inventory
    for (uint i = 0; i < newInventory.length; i++) {
      ShipInventoryData memory inventoryData = ShipInventoryData(newInventory[i].itemId, newInventory[i].quantity);
      ShipInventoryLib.addInventory(shipId, inventoryData);
    }
  }
}
