// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { CreationProcessStarted } from "./SkillProcessEvents.sol";
import { SkillProcessData, PlayerData, ItemCreationData } from "../codegen/index.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";
import { PlayerInventoryUpdateUtil } from "../utils/PlayerInventoryUpdateUtil.sol";
import { SkillProcessUtil } from "../utils/SkillProcessUtil.sol";
import { SkillProcessId } from "../systems/SkillProcessId.sol";
import { SkillTypeItemIdPair } from "../systems/SkillTypeItemIdPair.sol";
import { ItemIds } from "../utils/ItemIds.sol";
import { Player, ItemCreation } from "../codegen/index.sol";
import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";
import { PlayerUtil } from "../utils/PlayerUtil.sol";

error ProcessAlreadyStarted(uint32 currentItemId, bool completed);
error NotEnoughEnergy(uint256 required, uint256 available);
error LowerThanRequiredLevel(uint16 required, uint16 current);

library SkillProcessStartCreationLogic {
  function verify(
    uint8 skillType,
    uint256 playerId,
    uint8 sequenceNumber,
    uint32 itemId,
    uint32 batchSize,
    SkillProcessData memory skillProcessData
  ) internal view returns (CreationProcessStarted memory) {

    PlayerData memory playerData = PlayerUtil.assertSenderIsPlayerOwner(playerId);
    ItemCreationData memory itemCreationData = ItemCreation.get(skillType, itemId);
    // TODO: Check retrieved PlayerData and ItemCreationData

    // uint256 availableEnergy;
    if (skillProcessData.itemId != ItemIds.unusedItem() && !skillProcessData.completed) {
      revert ProcessAlreadyStarted(skillProcessData.itemId, skillProcessData.completed);
    }

    SkillTypeItemIdPair memory itemCreationId = SkillTypeItemIdPair(skillType, itemId);
    SkillProcessId memory skillProcessId = SkillProcessId(skillType, playerId, sequenceNumber);

    (uint256 _playerId, uint8 _skillType, uint32 _itemId) = SkillProcessUtil.assertIdsAreConsistentForStartingCreation(
      playerId,
      itemCreationId,
      skillProcessId
    );

    if (playerData.level < itemCreationData.requirementsLevel) {
      revert LowerThanRequiredLevel(itemCreationData.requirementsLevel, playerData.level);
    }

    uint256 energyCost = itemCreationData.energyCost * batchSize;
    // if (availableEnergy < energyCost) {
    //   revert NotEnoughEnergy(energyCost, availableEnergy);
    // }

    uint64 creationTime = itemCreationData.baseCreationTime * batchSize;
    uint32 resourceCost = itemCreationData.resourceCost * batchSize;

    return
      CreationProcessStarted({
        skillType: _skillType,
        playerId: _playerId,
        sequenceNumber: sequenceNumber,
        itemId: _itemId,
        batchSize: batchSize,
        energyCost: uint64(energyCost),
        resourceCost: resourceCost,
        startedAt: uint64(block.timestamp),
        creationTime: creationTime
      });
  }

  function mutate(
    CreationProcessStarted memory creationProcessStarted,
    SkillProcessData memory skillProcessData
  ) internal returns (SkillProcessData memory) {
    //PlayerData memory playerData;

    skillProcessData.itemId = creationProcessStarted.itemId;
    skillProcessData.startedAt = creationProcessStarted.startedAt;
    skillProcessData.creationTime = creationProcessStarted.creationTime;
    skillProcessData.completed = false;
    skillProcessData.endedAt = 0;
    skillProcessData.batchSize = creationProcessStarted.batchSize;

    // Deduct energy (assuming energy is stored in the player data)
    // playerData.energy -= creationProcessStarted.energyCost;

    // Deduct resources from player inventory
    uint32 resourceType = ItemIds.resourceTypeRequiredForSkill(creationProcessStarted.skillType);
    PlayerInventoryUpdateUtil.subtractFromInventory(
      creationProcessStarted.playerId,
      resourceType,
      creationProcessStarted.resourceCost
    );

    return skillProcessData;
  }
}
