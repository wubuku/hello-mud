// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ShipInventoryIncreased } from "./ShipEvents.sol";
import { ShipData } from "../codegen/index.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";
import { ShipInventoryLib } from "../systems/ShipInventoryLib.sol";
import { ShipInventoryData } from "../codegen/index.sol";
import { SortedVectorUtil } from "../utils/SortedVectorUtil.sol";

library ShipIncreaseShipInventoryLogic {
  function verify(
    uint256 id,
    ItemIdQuantityPair[] memory items,
    ShipData memory shipData
  ) internal pure returns (ShipInventoryIncreased memory) {
    return ShipInventoryIncreased({ id: id, items: items });
  }

  function mutate(
    ShipInventoryIncreased memory shipInventoryIncreased,
    ShipData memory shipData
  ) internal returns (ShipData memory) {
    uint256 shipId = shipInventoryIncreased.id;
    ItemIdQuantityPair[] memory items = shipInventoryIncreased.items;
    ShipInventoryData[] memory currentInventory = ShipInventoryLib.getAllInventory_(shipId);
    ItemIdQuantityPair[] memory currentInventoryPairs = convertToItemIdQuantityPairs(currentInventory);
    ItemIdQuantityPair[] memory mergedInventory = SortedVectorUtil.mergeItemIdQuantityPairs(
      currentInventoryPairs,
      items
    );

    // Remove all
    uint64 currentCount = ShipInventoryLib.getInventoryCount(shipId);
    for (uint64 i = 0; i < currentCount; i++) {
      ShipInventoryLib.removeLastInventory(shipId);
    }
    for (uint i = 0; i < mergedInventory.length; i++) {
      ShipInventoryData memory inventoryData = ShipInventoryData(
        mergedInventory[i].itemId,
        mergedInventory[i].quantity
      );
      ShipInventoryLib.addInventory(shipId, inventoryData);
    }
  }

  function convertToItemIdQuantityPairs(
    ShipInventoryData[] memory inventory
  ) internal pure returns (ItemIdQuantityPair[] memory) {
    ItemIdQuantityPair[] memory pairs = new ItemIdQuantityPair[](inventory.length);
    for (uint i = 0; i < inventory.length; i++) {
      pairs[i] = ItemIdQuantityPair(inventory[i].inventoryItemId, inventory[i].inventoryQuantity);
    }
    return pairs;
  }
}
