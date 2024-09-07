// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { RosterShipAdded } from "./RosterEvents.sol";
import { RosterData } from "../codegen/index.sol";

library RosterAddShipLogic {
  function verify(
    uint256 playerId,
    uint32 sequenceNumber,
    uint256 shipId,
    uint64 position,
    RosterData memory rosterData
  ) internal pure returns (RosterShipAdded memory) {
    // TODO ...
    //return RosterShipAdded(...);
  }

  function mutate(
    RosterShipAdded memory rosterShipAdded,
    RosterData memory rosterData
  ) internal pure returns (RosterData memory) {
    // TODO ...
  }
}
