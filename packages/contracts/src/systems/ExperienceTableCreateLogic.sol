// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ExperienceTableCreated } from "./ExperienceTableEvents.sol";

library ExperienceTableCreateLogic {
  function verify(
    bool reservedBool1
  ) internal pure returns (ExperienceTableCreated memory) {
    return ExperienceTableCreated(reservedBool1);
  }

  function mutate(
    ExperienceTableCreated memory experienceTableCreated
  ) internal pure returns (bool) {
    bool reservedBool1;
    reservedBool1 = experienceTableCreated.reservedBool1;
    return reservedBool1;
  }
}
