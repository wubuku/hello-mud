// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ItemToShipAttributesCreated } from "./ItemToShipAttributesEvents.sol";
import { ItemToShipAttributesData } from "../codegen/index.sol";

/**
 * @title ItemToShipAttributesCreateLogic Library
 * @dev Implements the ItemToShipAttributes.Create method.
 */
library ItemToShipAttributesCreateLogic {
  /**
   * @notice Verifies the ItemToShipAttributes.Create command.
   * @return A ItemToShipAttributesCreated event struct.
   */
  function verify(
    uint32 itemId,
    uint32 denominator,
    uint32 attackNumerator,
    uint32 protectionNumerator,
    uint32 speedNumerator,
    uint32 healthNumerator
  ) internal pure returns (ItemToShipAttributesCreated memory) {
    return ItemToShipAttributesCreated(itemId, denominator, attackNumerator, protectionNumerator, speedNumerator, healthNumerator);
  }

  /**
   * @notice Performs the state mutation operation of ItemToShipAttributes.Create method.
   * @dev This function is called after verification to update the ItemToShipAttributes's state.
   * @param itemToShipAttributesCreated The ItemToShipAttributesCreated event struct from the verify function.
   * @return The new state of the ItemToShipAttributes.
   */
  function mutate(
    ItemToShipAttributesCreated memory itemToShipAttributesCreated
  ) internal pure returns (ItemToShipAttributesData memory) {
    ItemToShipAttributesData memory itemToShipAttributesData;
    itemToShipAttributesData.denominator = itemToShipAttributesCreated.denominator;
    itemToShipAttributesData.attackNumerator = itemToShipAttributesCreated.attackNumerator;
    itemToShipAttributesData.protectionNumerator = itemToShipAttributesCreated.protectionNumerator;
    itemToShipAttributesData.speedNumerator = itemToShipAttributesCreated.speedNumerator;
    itemToShipAttributesData.healthNumerator = itemToShipAttributesCreated.healthNumerator;
    return itemToShipAttributesData;
  }
}
