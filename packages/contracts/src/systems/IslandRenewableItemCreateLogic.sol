// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { IslandRenewableItemCreated } from "./IslandRenewableItemEvents.sol";

/**
 * @title IslandRenewableItemCreateLogic Library
 * @dev Implements the IslandRenewableItem.Create method.
 */
library IslandRenewableItemCreateLogic {
  /**
   * @notice Verifies the IslandRenewableItem.Create command.
   * @param quantityWeight The current state the IslandRenewableItem.
   * @return A IslandRenewableItemCreated event struct.
   */
  function verify(uint32 itemId, uint32 quantityWeight) internal pure returns (IslandRenewableItemCreated memory) {
    require(quantityWeight > 0, "Quantity weight must greater than 0.");
    return IslandRenewableItemCreated(itemId, quantityWeight);
  }

  /**
   * @notice Performs the state mutation operation of IslandRenewableItem.Create method.
   * @dev This function is called after verification to update the IslandRenewableItem's state.
   * @param islandRenewableItemCreated The IslandRenewableItemCreated event struct from the verify function.
   * @return The new state of the IslandRenewableItem.
   */
  function mutate(IslandRenewableItemCreated memory islandRenewableItemCreated) internal pure returns (uint32) {
    uint32 quantityWeight;
    quantityWeight = islandRenewableItemCreated.quantityWeight;
    return quantityWeight;
  }
}
