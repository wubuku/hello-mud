// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { CreationProcessCompleted } from "./SkillProcessEvents.sol";
import { SkillProcessData } from "../codegen/index.sol";

library SkillProcessCompleteCreationLogic {
  function verify(
    uint8 skillType,
    uint256 playerId,
    uint8 sequenceNumber,
    SkillProcessData memory skillProcessData
  ) internal pure returns (CreationProcessCompleted memory) {
    // TODO ...
    //return CreationProcessCompleted(...);
  }

  function mutate(
    CreationProcessCompleted memory creationProcessCompleted,
    SkillProcessData memory skillProcessData
  ) internal pure returns (SkillProcessData memory) {
    // TODO ...
  }
}
