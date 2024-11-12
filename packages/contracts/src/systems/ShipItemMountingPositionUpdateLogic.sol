// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ShipItemMountingPositionUpdated } from "./ShipItemMountingPositionEvents.sol";

/**
 * @title ShipItemMountingPositionUpdateLogic Library
 * @dev Implements the ShipItemMountingPosition.Update method.
 */
library ShipItemMountingPositionUpdateLogic {
  /**
   * @notice Verifies the ShipItemMountingPosition.Update command.
   * @param s_equipmentCapacity The current state the ShipItemMountingPosition.
   * @return A ShipItemMountingPositionUpdated event struct.
   */
  function verify(
    uint32 itemId,
    uint8 mountingPosition,
    uint8 equipmentCapacity,
    uint8 s_equipmentCapacity
  ) internal pure returns (ShipItemMountingPositionUpdated memory) {
    return ShipItemMountingPositionUpdated(itemId, mountingPosition, equipmentCapacity);
  }

  /**
   * @notice Performs the state mutation operation of ShipItemMountingPosition.Update method.
   * @dev This function is called after verification to update the ShipItemMountingPosition's state.
   * @param shipItemMountingPositionUpdated The ShipItemMountingPositionUpdated event struct from the verify function.
   * @param equipmentCapacity The current state of the ShipItemMountingPosition.
   * @return The new state of the ShipItemMountingPosition.
   */
  function mutate(
    ShipItemMountingPositionUpdated memory shipItemMountingPositionUpdated,
    uint8 equipmentCapacity
  ) internal pure returns (uint8) {
    equipmentCapacity = shipItemMountingPositionUpdated.equipmentCapacity;
    return equipmentCapacity;
  }
}
