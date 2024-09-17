// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { RosterCreated } from "./RosterEvents.sol";
import { RosterData } from "../codegen/index.sol";

library RosterCreateLogic {
  function verify(
    uint256 playerId,
    uint32 sequenceNumber,
    RosterData memory rosterData
  ) internal pure returns (RosterCreated memory) {
    // TODO ...
    //return RosterCreated(...);
  }

  function mutate(
    RosterCreated memory rosterCreated,
    RosterData memory rosterData
  ) internal pure returns (RosterData memory) {
    // TODO ...
  }
}
