// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { PositionUpdated } from "./PositionEvents.sol";
import { PositionData } from "../codegen/index.sol";

library PositionUpdateLogic {
  function verify(
    address player,
    int32 x,
    int32 y,
    string memory description,
    PositionData memory positionData
  ) internal pure returns (PositionUpdated memory) {
    positionData.x; // silence the warning
    return PositionUpdated(player, x, y, description);
  }

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
