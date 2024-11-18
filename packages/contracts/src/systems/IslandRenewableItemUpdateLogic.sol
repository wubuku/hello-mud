// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { IslandRenewableItemUpdated } from "./IslandRenewableItemEvents.sol";

/**
 * @title IslandRenewableItemUpdateLogic Library
 * @dev Implements the IslandRenewableItem.Update method.
 */
library IslandRenewableItemUpdateLogic {
  /**
   * @notice Verifies the IslandRenewableItem.Update command.
   * @param s_quantityWeight The current state the IslandRenewableItem.
   * @return A IslandRenewableItemUpdated event struct.
   */
  function verify(
    uint32 itemId,
    uint32 quantityWeight,
    uint32 s_quantityWeight
  ) internal pure returns (IslandRenewableItemUpdated memory) {
    require(quantityWeight > 0, "Quantity weight must greater than 0.");
    return IslandRenewableItemUpdated(itemId, quantityWeight);
  }

  /**
   * @notice Performs the state mutation operation of IslandRenewableItem.Update method.
   * @dev This function is called after verification to update the IslandRenewableItem's state.
   * @param islandRenewableItemUpdated The IslandRenewableItemUpdated event struct from the verify function.
   * @param quantityWeight The current state of the IslandRenewableItem.
   * @return The new state of the IslandRenewableItem.
   */
  function mutate(
    IslandRenewableItemUpdated memory islandRenewableItemUpdated,
    uint32 quantityWeight
  ) internal pure returns (uint32) {
    quantityWeight = islandRenewableItemUpdated.quantityWeight;
    return quantityWeight;
  }
}
