// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { RosterShipsPositionAdjusted } from "./RosterEvents.sol";
import { RosterData } from "../codegen/index.sol";

library RosterAdjustShipsPositionLogic {
  function verify(
    uint256 playerId,
    uint32 sequenceNumber,
    uint64[] memory positions,
    uint256[] memory shipIds,
    RosterData memory rosterData
  ) internal pure returns (RosterShipsPositionAdjusted memory) {
    return RosterShipsPositionAdjusted(playerId, sequenceNumber, positions, shipIds);
  }

  function mutate(
    RosterShipsPositionAdjusted memory rosterShipsPositionAdjusted,
    RosterData memory rosterData
  ) internal pure returns (RosterData memory) {
    return rosterData;
    // TODO ...
  }
}
