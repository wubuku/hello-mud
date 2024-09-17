// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ExperienceTableCreated } from "./ExperienceTableEvents.sol";

library ExperienceTableCreateLogic {
  function verify(
    bool existing
  ) internal pure returns (ExperienceTableCreated memory) {
    return ExperienceTableCreated(existing);
  }

  function mutate(
    ExperienceTableCreated memory experienceTableCreated
  ) internal pure returns (bool) {
    bool existing;
    existing = experienceTableCreated.existing;
    return existing;
  }
}
