// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ExperienceTableUpdated } from "./ExperienceTableEvents.sol";

library ExperienceTableUpdateLogic {
  function verify(
    bool reservedBool1,
    bool s_reservedBool1
  ) internal pure returns (ExperienceTableUpdated memory) {
    return ExperienceTableUpdated(reservedBool1);
  }

  function mutate(
    ExperienceTableUpdated memory experienceTableUpdated,
    bool reservedBool1
  ) internal pure returns (bool) {
    reservedBool1 = experienceTableUpdated.existing;
    return reservedBool1;
  }
}
