// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { PlayerItemsDeducted } from "./PlayerEvents.sol";
import { PlayerData } from "../codegen/index.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";
import { PlayerInventoryUpdateUtil } from "./PlayerInventoryUpdateUtil.sol";

library PlayerDeductItemsLogic {
  function verify(
    uint256 id,
    ItemIdQuantityPair[] memory items,
    PlayerData memory playerData
  ) internal pure returns (PlayerItemsDeducted memory) {
    return PlayerItemsDeducted(id, items);
  }

  function mutate(
    PlayerItemsDeducted memory playerItemsDeducted,
    PlayerData memory playerData
  ) internal returns (PlayerData memory) {
    uint256 playerId = playerItemsDeducted.id;
    ItemIdQuantityPair[] memory items = playerItemsDeducted.items;

    for (uint i = 0; i < items.length; i++) {
      ItemIdQuantityPair memory item = items[i];
      PlayerInventoryUpdateUtil.subtractFromInventory(playerId, item.itemId, item.quantity);
    }

    return playerData;
  }
}
