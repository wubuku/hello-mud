// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ShipItemUpdated } from "./ShipItemEvents.sol";
import { ShipItemData } from "../codegen/index.sol";

/**
 * @title ShipItemUpdateLogic Library
 * @dev Implements the ShipItem.Update method.
 */
library ShipItemUpdateLogic {
  /**
   * @notice Verifies the ShipItem.Update command.
   * @param shipItemData The current state the ShipItem.
   * @return A ShipItemUpdated event struct.
   */
  function verify(
    uint32 itemId,
    uint8 type_,
    uint32 shipHealthPoints,
    uint8 mountingPosition,
    uint8 capacityUsage,
    uint8 attackBoost,
    uint8 protectionBoost,
    uint8 speedBoost,
    uint8 healthBoost,
    ShipItemData memory shipItemData
  ) internal pure returns (ShipItemUpdated memory) {
    return ShipItemUpdated(itemId, type_, shipHealthPoints, mountingPosition, capacityUsage, attackBoost, protectionBoost, speedBoost, healthBoost);
  }

  /**
   * @notice Performs the state mutation operation of ShipItem.Update method.
   * @dev This function is called after verification to update the ShipItem's state.
   * @param shipItemUpdated The ShipItemUpdated event struct from the verify function.
   * @param shipItemData The current state of the ShipItem.
   * @return The new state of the ShipItem.
   */
  function mutate(
    ShipItemUpdated memory shipItemUpdated,
    ShipItemData memory shipItemData
  ) internal pure returns (ShipItemData memory) {
    shipItemData.type_ = shipItemUpdated.type_;
    shipItemData.shipHealthPoints = shipItemUpdated.shipHealthPoints;
    shipItemData.mountingPosition = shipItemUpdated.mountingPosition;
    shipItemData.capacityUsage = shipItemUpdated.capacityUsage;
    shipItemData.attackBoost = shipItemUpdated.attackBoost;
    shipItemData.protectionBoost = shipItemUpdated.protectionBoost;
    shipItemData.speedBoost = shipItemUpdated.speedBoost;
    shipItemData.healthBoost = shipItemUpdated.healthBoost;
    return shipItemData;
  }
}
