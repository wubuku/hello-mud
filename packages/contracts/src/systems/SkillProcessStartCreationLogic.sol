// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { CreationProcessStarted } from "./SkillProcessEvents.sol";
import { SkillProcessData } from "../codegen/index.sol";

library SkillProcessStartCreationLogic {
  function verify(
    uint8 skillType,
    uint256 playerId,
    uint8 sequenceNumber,
    uint32 batchSize,
    uint32 itemId,
    SkillProcessData memory skillProcessData
  ) internal pure returns (CreationProcessStarted memory) {
    // TODO ...
    //return CreationProcessStarted(...);
  }

  function mutate(
    CreationProcessStarted memory creationProcessStarted,
    SkillProcessData memory skillProcessData
  ) internal pure returns (SkillProcessData memory) {
    // TODO ...
  }
}
