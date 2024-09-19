// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { SkillProcessCreated } from "./SkillProcessEvents.sol";
import { SkillProcessData } from "../codegen/index.sol";

library SkillProcessCreateLogic {
  function verify(
    uint8 skillType,
    uint256 playerId,
    uint8 sequenceNumber
  ) internal pure returns (SkillProcessCreated memory) {
    return SkillProcessCreated(skillType, playerId, sequenceNumber);
    //itemId, startedAt, creationTime, completed, endedAt, batchSize);
  }

  function mutate(
    SkillProcessCreated memory skillProcessCreated
  ) internal pure returns (SkillProcessData memory) {
    SkillProcessData memory skillProcessData;
    //skillProcessData.itemId = skillProcessCreated.itemId;
    //abiskillProcessData.startedAt = skillProcessCreated.startedAt;
    //skillProcessData.creationTime = skillProcessCreated.creationTime;
    //skillProcessData.completed = skillProcessCreated.completed;
    //skillProcessData.endedAt = skillProcessCreated.endedAt;
    //skillProcessData.batchSize = skillProcessCreated.batchSize;
    skillProcessData.existing = true;
    return skillProcessData;
  }
}
