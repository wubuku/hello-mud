// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ShipItemCreated } from "./ShipItemEvents.sol";
import { ShipItemData } from "../codegen/index.sol";

/**
 * @title ShipItemCreateLogic Library
 * @dev Implements the ShipItem.Create method.
 */
library ShipItemCreateLogic {
  /**
   * @notice Verifies the ShipItem.Create command.
   * @return A ShipItemCreated event struct.
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
    uint8 healthBoost
  ) internal pure returns (ShipItemCreated memory) {
    return ShipItemCreated(itemId, type_, shipHealthPoints, mountingPosition, capacityUsage, attackBoost, protectionBoost, speedBoost, healthBoost);
  }

  /**
   * @notice Performs the state mutation operation of ShipItem.Create method.
   * @dev This function is called after verification to update the ShipItem's state.
   * @param shipItemCreated The ShipItemCreated event struct from the verify function.
   * @return The new state of the ShipItem.
   */
  function mutate(
    ShipItemCreated memory shipItemCreated
  ) internal pure returns (ShipItemData memory) {
    ShipItemData memory shipItemData;
    shipItemData.type_ = shipItemCreated.type_;
    shipItemData.shipHealthPoints = shipItemCreated.shipHealthPoints;
    shipItemData.mountingPosition = shipItemCreated.mountingPosition;
    shipItemData.capacityUsage = shipItemCreated.capacityUsage;
    shipItemData.attackBoost = shipItemCreated.attackBoost;
    shipItemData.protectionBoost = shipItemCreated.protectionBoost;
    shipItemData.speedBoost = shipItemCreated.speedBoost;
    shipItemData.healthBoost = shipItemCreated.healthBoost;
    return shipItemData;
  }
}
