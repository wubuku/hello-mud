// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { PlayerAirdropped } from "./PlayerEvents.sol";
import { PlayerData, PlayerInventoryData } from "../codegen/index.sol";
import { PlayerInventoryLib } from "./PlayerInventoryLib.sol";

library PlayerAirdropLogic {
  function verify(
    uint256 id,
    uint32 itemId,
    uint32 quantity,
    PlayerData memory playerData
  ) internal pure returns (PlayerAirdropped memory) {
    // Verify the input parameters
    require(id != 0, "Player ID cannot be zero");
    require(itemId != 0, "Item ID cannot be zero");
    require(quantity > 0, "Quantity must be greater than zero");

    // Create and return the PlayerAirdropped event
    return PlayerAirdropped(id, itemId, quantity);
  }

  function mutate(
    PlayerAirdropped memory playerAirdropped,
    PlayerData memory playerData
  ) internal returns (PlayerData memory) {
    uint256 playerId = playerAirdropped.id;
    uint32 itemId = playerAirdropped.itemId;
    uint32 quantity = playerAirdropped.quantity;

    uint64 inventoryCount = PlayerInventoryLib.getInventoryCount(playerId);
    bool itemFound = false;

    // Iterate through the inventory without loading all items at once
    for (uint64 i = 0; i < inventoryCount; i++) {
      PlayerInventoryData memory item = PlayerInventoryLib.getInventoryByIndex(playerId, i);
      if (item.inventoryItemId == itemId) {
        // Update existing item quantity
        item.inventoryQuantity += quantity;
        PlayerInventoryLib.updateInventory(playerId, i, item);
        itemFound = true;
        break;
      }
    }

    // If item not found, add new inventory item
    if (!itemFound) {
      PlayerInventoryData memory newItem = PlayerInventoryData({
        inventoryItemId: itemId,
        inventoryQuantity: quantity
      });
      PlayerInventoryLib.addInventory(playerId, newItem);
    }

    // Return updated player data
    return playerData;
  }
}
