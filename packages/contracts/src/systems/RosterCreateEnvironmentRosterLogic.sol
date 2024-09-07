// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { EnvironmentRosterCreated } from "./RosterEvents.sol";
import { RosterData } from "../codegen/index.sol";

library RosterCreateEnvironmentRosterLogic {
  function verify(
    uint256 playerId,
    uint32 sequenceNumber,
    int32 coordinatesX,
    int32 coordinatesY,
    uint32 shipResourceQuantity,
    uint32 shipBaseResourceQuantity,
    uint32 baseExperience
  ) internal pure returns (EnvironmentRosterCreated memory) {
    // TODO ...
    //return EnvironmentRosterCreated(...);
  }

  function mutate(
    EnvironmentRosterCreated memory environmentRosterCreated
  ) internal pure returns (RosterData memory) {
    RosterData memory rosterData;
    // TODO ...
    return rosterData;
  }
}
