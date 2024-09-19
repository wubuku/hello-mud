// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { PlayerInventoryData } from "../codegen/index.sol";
import { PlayerInventoryLib } from "./PlayerInventoryLib.sol";

library PlayerInventoryUpdateUtil {
  error InsufficientItemQuantity(uint32 itemId, uint32 available, uint32 requested);

  function addOrUpdateInventory(uint256 playerId, uint32 itemId, uint32 quantityIncreased) internal {
    uint64 inventoryCount = PlayerInventoryLib.getInventoryCount(playerId);
    bool itemFound = false;

    // Iterate through the inventory without loading all items at once
    for (uint64 i = 0; i < inventoryCount; i++) {
      PlayerInventoryData memory inventoryItem = PlayerInventoryLib.getInventoryByIndex(playerId, i);
      if (inventoryItem.inventoryItemId == itemId) {
        // Update existing item quantity
        inventoryItem.inventoryQuantity += quantityIncreased;
        PlayerInventoryLib.updateInventory(playerId, i, inventoryItem);
        itemFound = true;
        break;
      }
    }

    // If item not found, add new inventory item
    if (!itemFound) {
      PlayerInventoryData memory newItem = PlayerInventoryData({
        inventoryItemId: itemId,
        inventoryQuantity: quantityIncreased
      });
      PlayerInventoryLib.addInventory(playerId, newItem);
    }
  }

  function subtractFromInventory(uint256 playerId, uint32 itemId, uint32 quantityDecreased) internal {
    uint64 inventoryCount = PlayerInventoryLib.getInventoryCount(playerId);
    bool itemFound = false;

    // Iterate through the inventory without loading all items at once
    for (uint64 i = 0; i < inventoryCount; i++) {
      PlayerInventoryData memory inventoryItem = PlayerInventoryLib.getInventoryByIndex(playerId, i);
      if (inventoryItem.inventoryItemId == itemId) {
        // Check if there's enough quantity to subtract
        if (inventoryItem.inventoryQuantity < quantityDecreased) {
          revert InsufficientItemQuantity(itemId, inventoryItem.inventoryQuantity, quantityDecreased);
        }
        // Update existing item quantity
        inventoryItem.inventoryQuantity -= quantityDecreased;
        PlayerInventoryLib.updateInventory(playerId, i, inventoryItem);
        itemFound = true;
        break;
      }
    }

    // If item not found, revert the transaction
    if (!itemFound) {
      revert InsufficientItemQuantity(itemId, 0, quantityDecreased);
    }
  }

  function getItemQuantity(uint256 playerId, uint32 itemId) internal view returns (uint32) {
    uint64 inventoryCount = PlayerInventoryLib.getInventoryCount(playerId);

    for (uint64 i = 0; i < inventoryCount; i++) {
      PlayerInventoryData memory inventoryItem = PlayerInventoryLib.getInventoryByIndex(playerId, i);
      if (inventoryItem.inventoryItemId == itemId) {
        return inventoryItem.inventoryQuantity;
      }
    }

    return 0; // Return 0 if item not found
  }
}
