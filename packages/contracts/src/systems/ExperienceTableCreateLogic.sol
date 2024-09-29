// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ExperienceTableCreated } from "./ExperienceTableEvents.sol";
//import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";

/**
 * @title ExperienceTableCreateLogic Library
 * @dev Implements the ExperienceTable.Create method.
 */
library ExperienceTableCreateLogic {
  /**
   * @notice Verifies the ExperienceTable.Create command.
   * @param existing The current state the ExperienceTable.
   * @return A ExperienceTableCreated event struct.
   */
  function verify(
    bool existing
  ) internal pure returns (ExperienceTableCreated memory) {
    return ExperienceTableCreated(existing);
  }

  /**
   * @notice Performs the state mutation operation of ExperienceTable.Create method.
   * @dev This function is called after verification to update the ExperienceTable's state.
   * @param experienceTableCreated The ExperienceTableCreated event struct from the verify function.
   * @return The new state of the ExperienceTable.
   */
  function mutate(
    ExperienceTableCreated memory experienceTableCreated
  ) internal pure returns (bool) {
    bool existing;
    existing = experienceTableCreated.existing;
    return existing;
  }
}
