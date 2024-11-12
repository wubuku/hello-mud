// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ItemToShipAttributesUpdated } from "./ItemToShipAttributesEvents.sol";
import { ItemToShipAttributesData } from "../codegen/index.sol";

/**
 * @title ItemToShipAttributesUpdateLogic Library
 * @dev Implements the ItemToShipAttributes.Update method.
 */
library ItemToShipAttributesUpdateLogic {
  /**
   * @notice Verifies the ItemToShipAttributes.Update command.
   * @param itemToShipAttributesData The current state the ItemToShipAttributes.
   * @return A ItemToShipAttributesUpdated event struct.
   */
  function verify(
    uint32 itemId,
    uint32 denominator,
    uint32 attackNumerator,
    uint32 protectionNumerator,
    uint32 speedNumerator,
    uint32 healthNumerator,
    ItemToShipAttributesData memory itemToShipAttributesData
  ) internal pure returns (ItemToShipAttributesUpdated memory) {
    return ItemToShipAttributesUpdated(itemId, denominator, attackNumerator, protectionNumerator, speedNumerator, healthNumerator);
  }

  /**
   * @notice Performs the state mutation operation of ItemToShipAttributes.Update method.
   * @dev This function is called after verification to update the ItemToShipAttributes's state.
   * @param itemToShipAttributesUpdated The ItemToShipAttributesUpdated event struct from the verify function.
   * @param itemToShipAttributesData The current state of the ItemToShipAttributes.
   * @return The new state of the ItemToShipAttributes.
   */
  function mutate(
    ItemToShipAttributesUpdated memory itemToShipAttributesUpdated,
    ItemToShipAttributesData memory itemToShipAttributesData
  ) internal pure returns (ItemToShipAttributesData memory) {
    itemToShipAttributesData.denominator = itemToShipAttributesUpdated.denominator;
    itemToShipAttributesData.attackNumerator = itemToShipAttributesUpdated.attackNumerator;
    itemToShipAttributesData.protectionNumerator = itemToShipAttributesUpdated.protectionNumerator;
    itemToShipAttributesData.speedNumerator = itemToShipAttributesUpdated.speedNumerator;
    itemToShipAttributesData.healthNumerator = itemToShipAttributesUpdated.healthNumerator;
    return itemToShipAttributesData;
  }
}
