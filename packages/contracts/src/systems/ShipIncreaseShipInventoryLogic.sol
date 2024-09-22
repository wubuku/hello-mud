// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ShipInventoryIncreased } from "./ShipEvents.sol";
import { ShipData } from "../codegen/index.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";
import { ShipInventoryLib } from "../systems/ShipInventoryLib.sol";
import { ShipInventoryData } from "../codegen/index.sol";
import { SortedVectorUtil } from "../utils/SortedVectorUtil.sol";
import { ShipInventoryUpdateUtil } from "../utils/ShipInventoryUpdateUtil.sol";

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
    ItemIdQuantityPair[] memory currentInventoryPairs = ShipInventoryUpdateUtil.convertToItemIdQuantityPairs(
      currentInventory
    );
    ItemIdQuantityPair[] memory mergedInventory = SortedVectorUtil.mergeItemIdQuantityPairs(
      currentInventoryPairs,
      items
    );

    ShipInventoryUpdateUtil.updateShipAllInventory(shipId, mergedInventory);

    return shipData;
  }
}
