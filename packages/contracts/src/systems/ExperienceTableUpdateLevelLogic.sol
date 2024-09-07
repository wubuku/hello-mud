// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ExperienceLevelUpdated } from "./ExperienceTableEvents.sol";

library ExperienceTableUpdateLevelLogic {
  function verify(
    uint16 level,
    uint32 experience,
    uint32 difference,
    bool reservedBool1
  ) internal pure returns (ExperienceLevelUpdated memory) {
    // TODO ...
    //return ExperienceLevelUpdated(...);
  }

  function mutate(
    ExperienceLevelUpdated memory experienceLevelUpdated,
    bool reservedBool1
  ) internal pure returns (bool) {
    // TODO ...
  }
}
