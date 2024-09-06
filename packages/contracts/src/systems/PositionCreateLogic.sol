// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { PositionCreated } from "./PositionEvents.sol";
import { PositionData } from "../codegen/index.sol";

library PositionCreateLogic {
  function verify(
    address player,
    int32 x,
    int32 y,
    string memory description
  ) internal pure returns (PositionCreated memory) {
    return PositionCreated(player, x, y, description);
  }

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
