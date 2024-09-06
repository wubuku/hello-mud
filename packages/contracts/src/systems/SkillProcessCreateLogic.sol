// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { SkillProcessCreated } from "./SkillProcessEvents.sol";
import { SkillProcessData } from "../codegen/index.sol";

library SkillProcessCreateLogic {
  function verify(
    uint8 skillProcessIdSkillType,
    uint256 skillProcessIdPlayerId,
    uint8 skillProcessIdSequenceNumber,
    uint32 itemId,
    uint64 startedAt,
    uint64 creationTime,
    bool completed,
    uint64 endedAt,
    uint32 batchSize
  ) internal pure returns (SkillProcessCreated memory) {
    return SkillProcessCreated(skillProcessIdSkillType, skillProcessIdPlayerId, skillProcessIdSequenceNumber, itemId, startedAt, creationTime, completed, endedAt, batchSize);
  }

  function mutate(
    SkillProcessCreated memory skillProcessCreated
  ) internal pure returns (SkillProcessData memory) {
    // TODO ...
  }
}
