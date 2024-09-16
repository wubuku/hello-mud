// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { RosterSetSail } from "./RosterEvents.sol";
import { RosterData } from "../codegen/index.sol";

library RosterSetSailLogic {
  function verify(
    uint256 playerId,
    uint32 sequenceNumber,
    uint32 targetCoordinatesX,
    uint32 targetCoordinatesY,
    uint64 sailDuration,
    uint32 updatedCoordinatesX,
    uint32 updatedCoordinatesY,
    RosterData memory rosterData
  ) internal pure returns (RosterSetSail memory) {
    // TODO ...
    //return RosterSetSail(...);
  }

  function mutate(
    RosterSetSail memory rosterSetSail,
    RosterData memory rosterData
  ) internal pure returns (RosterData memory) {
    // TODO ...
  }
}
