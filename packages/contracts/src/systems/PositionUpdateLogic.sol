// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { PositionUpdated } from "./PositionEvents.sol";
import { PositionData } from "../codegen/index.sol";
//import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";

/**
 * @title PositionUpdateLogic Library
 * @dev Implements the Position.Update method.
 */
library PositionUpdateLogic {
  /**
   * @notice Verifies the Position.Update command.
   * @param positionData The current state the Position.
   * @return A PositionUpdated event struct.
   */
  function verify(
    address player,
    int32 x,
    int32 y,
    string memory description,
    PositionData memory positionData
  ) internal pure returns (PositionUpdated memory) {
    return PositionUpdated(player, x, y, description);
  }

  /**
   * @notice Performs the state mutation operation of Position.Update method.
   * @dev This function is called after verification to update the Position's state.
   * @param positionUpdated The PositionUpdated event struct from the verify function.
   * @param positionData The current state of the Position.
   * @return The new state of the Position.
   */
  function mutate(
    PositionUpdated memory positionUpdated,
    PositionData memory positionData
  ) internal pure returns (PositionData memory) {
    positionData.x = positionUpdated.x;
    positionData.y = positionUpdated.y;
    positionData.description = positionUpdated.description;
    return positionData;
  }
}
