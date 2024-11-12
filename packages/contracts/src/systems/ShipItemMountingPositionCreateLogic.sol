// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ShipItemMountingPositionCreated } from "./ShipItemMountingPositionEvents.sol";

/**
 * @title ShipItemMountingPositionCreateLogic Library
 * @dev Implements the ShipItemMountingPosition.Create method.
 */
library ShipItemMountingPositionCreateLogic {
  /**
   * @notice Verifies the ShipItemMountingPosition.Create command.
   * @param equipmentCapacity The current state the ShipItemMountingPosition.
   * @return A ShipItemMountingPositionCreated event struct.
   */
  function verify(
    uint32 itemId,
    uint8 mountingPosition,
    uint8 equipmentCapacity
  ) internal pure returns (ShipItemMountingPositionCreated memory) {
    return ShipItemMountingPositionCreated(itemId, mountingPosition, equipmentCapacity);
  }

  /**
   * @notice Performs the state mutation operation of ShipItemMountingPosition.Create method.
   * @dev This function is called after verification to update the ShipItemMountingPosition's state.
   * @param shipItemMountingPositionCreated The ShipItemMountingPositionCreated event struct from the verify function.
   * @return The new state of the ShipItemMountingPosition.
   */
  function mutate(
    ShipItemMountingPositionCreated memory shipItemMountingPositionCreated
  ) internal pure returns (uint8) {
    uint8 equipmentCapacity;
    equipmentCapacity = shipItemMountingPositionCreated.equipmentCapacity;
    return equipmentCapacity;
  }
}
