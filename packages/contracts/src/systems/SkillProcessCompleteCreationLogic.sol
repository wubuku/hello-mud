// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { CreationProcessCompleted } from "./SkillProcessEvents.sol";
import { SkillProcessData, PlayerData, ItemCreationData } from "../codegen/index.sol";
import { SkillProcessUtil } from "../utils/SkillProcessUtil.sol";
import { ItemIds } from "../utils/ItemIds.sol";
import { Player, ItemCreation } from "../codegen/index.sol";
import { ExperienceTableUtil } from "../utils/ExperienceTableUtil.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";
import { PlayerDelegatecallLib } from "../systems/PlayerDelegatecallLib.sol";
import { SkillTypeItemIdPair } from "./SkillTypeItemIdPair.sol";
import { SkillProcessId } from "./SkillProcessId.sol";

library SkillProcessCompleteCreationLogic {
  error ProcessNotStarted();
  error StillInProgress(uint64 currentTime, uint64 expectedCompletionTime);

  function verify(
    uint8 skillType,
    uint256 playerId,
    uint8 sequenceNumber,
    SkillProcessData memory skillProcessData
  ) internal view returns (CreationProcessCompleted memory) {
    PlayerData memory playerData = Player.get(playerId);
    ItemCreationData memory itemCreationData = ItemCreation.get(skillType, skillProcessData.itemId);

    (uint256 _playerId, uint8 _skillType, uint32 itemId) = SkillProcessUtil.assertIdsAreConsistentForCompletingCreation(
      playerId,
      SkillTypeItemIdPair(skillType, skillProcessData.itemId),
      SkillProcessId(skillType, playerId, sequenceNumber),
      skillProcessData
    );

    require(itemId != ItemIds.unusedItem() && !skillProcessData.completed, "Process not started");

    uint64 endedAt = uint64(block.timestamp);
    if (endedAt < skillProcessData.startedAt + skillProcessData.creationTime) {
      revert StillInProgress(endedAt, skillProcessData.startedAt + skillProcessData.creationTime);
    }

    uint32 batchSize = skillProcessData.batchSize;
    bool successful = true; // TODO: Implement success rate logic
    uint32 quantity = itemCreationData.baseQuantity * batchSize;
    uint32 increasedExperience = itemCreationData.baseExperience * batchSize;

    uint16 newLevel = ExperienceTableUtil.calculateNewLevel(
      playerData.level,
      playerData.experience,
      increasedExperience
    );

    return
      CreationProcessCompleted({
        skillType: _skillType,
        playerId: _playerId,
        sequenceNumber: sequenceNumber,
        itemId: itemId,
        startedAt: skillProcessData.startedAt,
        creationTime: skillProcessData.creationTime,
        endedAt: endedAt,
        successful: successful,
        quantity: quantity,
        experienceGained: increasedExperience,
        newLevel: newLevel
      });
  }

  function mutate(
    CreationProcessCompleted memory creationProcessCompleted,
    SkillProcessData memory skillProcessData
  ) internal returns (SkillProcessData memory) {
    skillProcessData.completed = true;
    skillProcessData.endedAt = creationProcessCompleted.endedAt;

    if (creationProcessCompleted.successful) {
      ItemIdQuantityPair[] memory items = new ItemIdQuantityPair[](1);
      items[0] = ItemIdQuantityPair(creationProcessCompleted.itemId, creationProcessCompleted.quantity);

      PlayerDelegatecallLib.increaseExperienceAndItems(
        creationProcessCompleted.playerId,
        creationProcessCompleted.experienceGained,
        items,
        creationProcessCompleted.newLevel
      );
    }

    return skillProcessData;
  }
}
