// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ExperienceTableUpdated } from "./ExperienceTableEvents.sol";
//import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";

/**
 * @title ExperienceTableUpdateLogic Library
 * @dev Implements the ExperienceTable.Update method.
 */
library ExperienceTableUpdateLogic {
  /**
   * @notice Verifies the ExperienceTable.Update command.
   * @param s_existing The current state the ExperienceTable.
   * @return A ExperienceTableUpdated event struct.
   */
  function verify(
    bool existing,
    bool s_existing
  ) internal pure returns (ExperienceTableUpdated memory) {
    return ExperienceTableUpdated(existing);
  }

  /**
   * @notice Performs the state mutation operation of ExperienceTable.Update method.
   * @dev This function is called after verification to update the ExperienceTable's state.
   * @param experienceTableUpdated The ExperienceTableUpdated event struct from the verify function.
   * @param existing The current state of the ExperienceTable.
   * @return The new state of the ExperienceTable.
   */
  function mutate(
    ExperienceTableUpdated memory experienceTableUpdated,
    bool existing
  ) internal pure returns (bool) {
    existing = experienceTableUpdated.existing;
    return existing;
  }
}
