// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { PositionCreated } from "./PositionEvents.sol";
import { PositionData } from "../codegen/index.sol";

/**
 * @title PositionCreateLogic Library
 * @dev Implements the Position.Create method.
 */
library PositionCreateLogic {
  /**
   * @notice Verifies the Position.Create command.
   * @return A PositionCreated event struct.
   */
  function verify(
    address player,
    int32 x,
    int32 y,
    string memory description
  ) internal pure returns (PositionCreated memory) {
    return PositionCreated(player, x, y, description);
  }

  /**
   * @notice Performs the state mutation operation of Position.Create method.
   * @dev This function is called after verification to update the Position's state.
   * @param positionCreated The PositionCreated event struct from the verify function.
   * @return The new state of the Position.
   */
  function mutate(
    PositionCreated memory positionCreated
  ) internal pure returns (PositionData memory) {
    PositionData memory positionData;
    positionData.x = positionCreated.x;
    positionData.y = positionCreated.y;
    positionData.description = positionCreated.description;
    return positionData;
  }
}
