// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { SkillProcessCreated } from "./SkillProcessEvents.sol";
import { SkillProcessData } from "../codegen/index.sol";

library SkillProcessCreateLogic {
  function verify(
    uint8 skillType,
    uint256 playerId,
    uint8 sequenceNumber,
    uint32 itemId,
    uint64 startedAt,
    uint64 creationTime,
    bool completed,
    uint64 endedAt,
    uint32 batchSize
  ) internal pure returns (SkillProcessCreated memory) {
    return SkillProcessCreated(skillType, playerId, sequenceNumber, itemId, startedAt, creationTime, completed, endedAt, batchSize);
  }

  function mutate(
    SkillProcessCreated memory skillProcessCreated
  ) internal pure returns (SkillProcessData memory) {
    SkillProcessData memory skillProcessData;
    skillProcessData.itemId = skillProcessCreated.itemId;
    skillProcessData.startedAt = skillProcessCreated.startedAt;
    skillProcessData.creationTime = skillProcessCreated.creationTime;
    skillProcessData.completed = skillProcessCreated.completed;
    skillProcessData.endedAt = skillProcessCreated.endedAt;
    skillProcessData.batchSize = skillProcessCreated.batchSize;
    return skillProcessData;
  }
}
