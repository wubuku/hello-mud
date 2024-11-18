// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ItemUpdated } from "./ItemEvents.sol";
import { ItemData } from "../codegen/index.sol";

/**
 * @title ItemUpdateLogic Library
 * @dev Implements the Item.Update method.
 */
library ItemUpdateLogic {
  /**
   * @notice Verifies the Item.Update command.
   * @param itemData The current state the Item.
   * @return A ItemUpdated event struct.
   */
  function verify(
    uint32 itemId,
    bool requiredForCompletion,
    uint32 sellsFor,
    string memory name,
    ItemData memory itemData
  ) internal pure returns (ItemUpdated memory) {
    return ItemUpdated(itemId, requiredForCompletion, sellsFor, name);
  }

  /**
   * @notice Performs the state mutation operation of Item.Update method.
   * @dev This function is called after verification to update the Item's state.
   * @param itemUpdated The ItemUpdated event struct from the verify function.
   * @param itemData The current state of the Item.
   * @return The new state of the Item.
   */
  function mutate(ItemUpdated memory itemUpdated, ItemData memory itemData) internal pure returns (ItemData memory) {
    itemData.requiredForCompletion = itemUpdated.requiredForCompletion;
    itemData.sellsFor = itemUpdated.sellsFor;
    itemData.name = itemUpdated.name;
    return itemData;
  }
}
