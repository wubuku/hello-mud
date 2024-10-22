// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ProductionProcessCompleted } from "./SkillProcessEvents.sol";
import { SkillProcessData, PlayerData, ItemProductionData } from "../codegen/index.sol";
import { SkillProcessUtil } from "../utils/SkillProcessUtil.sol";
import { ItemIds } from "../utils/ItemIds.sol";
import { Player, ItemProduction } from "../codegen/index.sol";
import { ExperienceTableUtil } from "../utils/ExperienceTableUtil.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";
import { PlayerDelegatecallLib } from "../systems/PlayerDelegatecallLib.sol";
import { SkillTypeItemIdPair } from "./SkillTypeItemIdPair.sol";
import { SkillProcessId } from "./SkillProcessId.sol";

library SkillProcessCompleteProductionLogic {
  error ProcessNotStarted(uint32 itemId, bool completed);
  error ItemProducesIndividuals(uint32 itemId);
  error StillInProgress(uint64 currentTime, uint64 expectedCompletionTime);

  function verify(
    uint8 skillType,
    uint256 playerId,
    uint8 sequenceNumber,
    SkillProcessData memory skillProcessData
  ) internal view returns (ProductionProcessCompleted memory) {
    PlayerData memory playerData = Player.get(playerId);
    ItemProductionData memory itemProductionData = ItemProduction.get(skillType, skillProcessData.itemId);

    (uint256 _playerId, uint8 _skillType, uint32 itemId) = SkillProcessUtil
      .assertIdsAreConsistentForCompletingProduction(
        playerId,
        SkillTypeItemIdPair(skillType, skillProcessData.itemId),
        SkillProcessId(skillType, playerId, sequenceNumber),
        skillProcessData
      );

    if (itemId == ItemIds.unusedItem() || skillProcessData.completed) {
      revert ProcessNotStarted(itemId, skillProcessData.completed);
    }

    if (ItemIds.shouldProduceIndividuals(itemId)) {
      revert ItemProducesIndividuals(itemId);
    }

    uint64 endedAt = uint64(block.timestamp);
    if (endedAt < skillProcessData.startedAt + skillProcessData.creationTime) {
      revert StillInProgress(endedAt, skillProcessData.startedAt + skillProcessData.creationTime);
    }

    uint32 batchSize = skillProcessData.batchSize;
    bool successful = true; // TODO: Always successful for now
    uint32 quantity = itemProductionData.baseQuantity * batchSize;
    uint32 increasedExperience = itemProductionData.baseExperience * batchSize;

    uint16 newLevel = ExperienceTableUtil.calculateNewLevel(
      playerData.level,
      playerData.experience,
      increasedExperience
    );

    return
      ProductionProcessCompleted({
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
    ProductionProcessCompleted memory productionProcessCompleted,
    SkillProcessData memory skillProcessData
  ) internal returns (SkillProcessData memory) {
    skillProcessData.completed = true;
    skillProcessData.endedAt = productionProcessCompleted.endedAt;

    if (productionProcessCompleted.successful) {
      ItemIdQuantityPair[] memory items = new ItemIdQuantityPair[](1);
      items[0] = ItemIdQuantityPair(productionProcessCompleted.itemId, productionProcessCompleted.quantity);

      PlayerDelegatecallLib.increaseExperienceAndItems(
        productionProcessCompleted.playerId,
        productionProcessCompleted.experienceGained,
        items,
        productionProcessCompleted.newLevel
      );
    }

    return skillProcessData;
  }
}
