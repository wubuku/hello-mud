// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { RosterShipTransferred } from "./RosterEvents.sol";
import { RosterData } from "../codegen/index.sol";

library RosterTransferShipLogic {
  function verify(
    uint256 playerId,
    uint32 sequenceNumber,
    uint256 shipId,
    uint256 toRosterPlayerId,
    uint32 toRosterSequenceNumber,
    uint64 toPosition,
    RosterData memory rosterData
  ) internal pure returns (RosterShipTransferred memory) {
    // TODO ...
    //return RosterShipTransferred(...);
  }

  function mutate(
    RosterShipTransferred memory rosterShipTransferred,
    RosterData memory rosterData
  ) internal pure returns (RosterData memory) {
    // TODO ...
  }
}
