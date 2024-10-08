// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ItemCreated } from "./ItemEvents.sol";
import { ItemData } from "../codegen/index.sol";

library ItemCreateLogic {
  function verify(
    uint32 itemId,
    bool requiredForCompletion,
    uint32 sellsFor,
    string memory name
  ) internal pure returns (ItemCreated memory) {
    return ItemCreated(itemId, requiredForCompletion, sellsFor, name);
  }

  function mutate(ItemCreated memory itemCreated) internal pure returns (ItemData memory) {
    return ItemData(itemCreated.requiredForCompletion, itemCreated.sellsFor, itemCreated.name);
  }
}
