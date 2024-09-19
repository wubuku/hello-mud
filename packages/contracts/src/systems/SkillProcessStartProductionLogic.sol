// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ProductionProcessStarted } from "./SkillProcessEvents.sol";
import { SkillProcessData, PlayerData, ItemProductionData } from "../codegen/index.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";
import { PlayerInventoryUpdateUtil } from "./PlayerInventoryUpdateUtil.sol";
import { SkillProcessUtil } from "../utils/SkillProcessUtil.sol";
import { SkillProcessId } from "../systems/SkillProcessId.sol";
import { SkillTypeItemIdPair } from "../systems/SkillTypeItemIdPair.sol";
import { ItemIds } from "../utils/ItemIds.sol";
import { Player, ItemProduction } from "../codegen/index.sol";
import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";

error ProcessAlreadyStarted(uint32 currentItemId, bool completed);
error NotEnoughEnergy(uint256 required, uint256 available);
error LowerThanRequiredLevel(uint16 required, uint16 current);
error SenderHasNoPermission(address sender, address owner);
error ItemProducesIndividuals(uint32 itemId);

library SkillProcessStartProductionLogic {
  function verify(
    uint8 skillType,
    uint256 playerId,
    uint8 sequenceNumber,
    uint32 itemId,
    uint32 batchSize,
    SkillProcessData memory skillProcessData
  ) internal view returns (ProductionProcessStarted memory) {
    PlayerData memory playerData = Player.get(playerId);
    ItemProductionData memory itemProductionData = ItemProduction.get(skillType, itemId);
    // TODO: Check retrieved PlayerData and ItemProductionData

    if (WorldContextConsumerLib._msgSender() != playerData.owner) {
      revert SenderHasNoPermission(WorldContextConsumerLib._msgSender(), playerData.owner);
    }

    if (skillProcessData.itemId != ItemIds.unusedItem() && !skillProcessData.completed) {
      revert ProcessAlreadyStarted(skillProcessData.itemId, skillProcessData.completed);
    }

    SkillTypeItemIdPair memory itemProductionId = SkillTypeItemIdPair(skillType, itemId);
    SkillProcessId memory skillProcessId = SkillProcessId(skillType, playerId, sequenceNumber);

    (uint256 _playerId, uint8 _skillType, uint32 _itemId) = SkillProcessUtil.assertIdsAreConsistentForStartingProduction(
      playerId,
      itemProductionId,
      skillProcessId
    );

    if (ItemIds.shouldProduceIndividuals(_itemId)) {
      revert ItemProducesIndividuals(_itemId);
    }

    if (playerData.level < itemProductionData.requirementsLevel) {
      revert LowerThanRequiredLevel(itemProductionData.requirementsLevel, playerData.level);
    }

    uint256 energyCost = itemProductionData.energyCost * batchSize;
    // TODO: Implement energy check
    // if (availableEnergy < energyCost) {
    //   revert NotEnoughEnergy(energyCost, availableEnergy);
    // }

    uint64 creationTime = itemProductionData.baseCreationTime * batchSize;
    ItemIdQuantityPair[] memory productionMaterials = createAndMultiplyItemIdQuantityPairs(
      itemProductionData.materialItemIds,
      itemProductionData.materialItemQuantities,
      batchSize
    );

    return
      ProductionProcessStarted({
        skillType: _skillType,
        playerId: _playerId,
        sequenceNumber: sequenceNumber,
        itemId: _itemId,
        batchSize: batchSize,
        energyCost: uint64(energyCost),
        startedAt: uint64(block.timestamp),
        creationTime: creationTime,
        productionMaterials: productionMaterials
      });
  }

  function mutate(
    ProductionProcessStarted memory productionProcessStarted,
    SkillProcessData memory skillProcessData
  ) internal returns (SkillProcessData memory) {
    skillProcessData.itemId = productionProcessStarted.itemId;
    skillProcessData.startedAt = productionProcessStarted.startedAt;
    skillProcessData.creationTime = productionProcessStarted.creationTime;
    skillProcessData.completed = false;
    skillProcessData.endedAt = 0;
    skillProcessData.batchSize = productionProcessStarted.batchSize;

    // TODO: Implement energy deduction
    // let energy_vault = skill_process::borrow_mut_energy_vault(skill_process);
    // balance::join(energy_vault, energy);

    PlayerInventoryUpdateUtil.subtractMultipleFromInventory(
      productionProcessStarted.playerId,
      productionProcessStarted.productionMaterials
    );

    return skillProcessData;
  }

  function createAndMultiplyItemIdQuantityPairs(
    uint32[] memory itemIds,
    uint32[] memory quantities,
    uint32 multiplier
  ) internal pure returns (ItemIdQuantityPair[] memory) {
    require(itemIds.length == quantities.length, "Arrays length mismatch");
    ItemIdQuantityPair[] memory result = new ItemIdQuantityPair[](itemIds.length);
    for (uint i = 0; i < itemIds.length; i++) {
      result[i] = ItemIdQuantityPair(itemIds[i], quantities[i] * multiplier);
    }
    return result;
  }
}
