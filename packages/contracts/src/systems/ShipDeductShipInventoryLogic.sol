// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ShipInventoryDeducted } from "./ShipEvents.sol";
import { ShipData } from "../codegen/index.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";
import { ShipInventoryLib } from "../systems/ShipInventoryLib.sol";
import { ShipInventoryData } from "../codegen/index.sol";
import { SortedVectorUtil } from "../utils/SortedVectorUtil.sol";
import { ShipInventoryUpdateUtil } from "../utils/ShipInventoryUpdateUtil.sol";

library ShipDeductShipInventoryLogic {
  function verify(
    uint256 id,
    ItemIdQuantityPair[] memory items,
    ShipData memory shipData
  ) internal pure returns (ShipInventoryDeducted memory) {
    return ShipInventoryDeducted({ id: id, items: items });
  }

  function mutate(
    ShipInventoryDeducted memory shipInventoryDeducted,
    ShipData memory shipData
  ) internal returns (ShipData memory) {
    uint256 shipId = shipInventoryDeducted.id;
    ItemIdQuantityPair[] memory itemsToDeduct = shipInventoryDeducted.items;
    ShipInventoryData[] memory currentInventory = ShipInventoryLib.getAllInventory_(shipId);
    ItemIdQuantityPair[] memory currentInventoryPairs = ShipInventoryUpdateUtil.convertToItemIdQuantityPairs(
      currentInventory
    );
    ItemIdQuantityPair[] memory updatedInventory = SortedVectorUtil.subtractItemIdQuantityPairs(
      currentInventoryPairs,
      itemsToDeduct
    );

    ShipInventoryUpdateUtil.updateShipAllInventory(shipId, updatedInventory);

    return shipData;
  }
}
