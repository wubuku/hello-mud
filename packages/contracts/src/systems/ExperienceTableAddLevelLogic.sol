// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ExperienceLevelAdded } from "./ExperienceTableEvents.sol";

library ExperienceTableAddLevelLogic {
  function verify(
    uint16 level,
    uint32 experience,
    uint32 difference,
    bool reservedBool1
  ) internal pure returns (ExperienceLevelAdded memory) {
    // TODO ...
    //return ExperienceLevelAdded(...);
  }

  function mutate(
    ExperienceLevelAdded memory experienceLevelAdded,
    bool reservedBool1
  ) internal pure returns (bool) {
    // TODO ...
  }
}
