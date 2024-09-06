// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ItemUpdated } from "./ItemEvents.sol";
import { ItemData } from "../codegen/index.sol";

library ItemUpdateLogic {
  function verify(
    uint32 itemId,
    bool requiredForCompletion,
    uint32 sellsFor,
    string memory name,
    ItemData memory itemData
  ) internal pure returns (ItemUpdated memory) {
    // TODO ...
    //return ItemUpdated(...);
  }

  function mutate(
    ItemUpdated memory itemUpdated,
    ItemData memory itemData
  ) internal pure returns (ItemData memory) {
    // TODO ...
  }
}
