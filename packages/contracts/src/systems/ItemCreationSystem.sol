// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { System } from "@latticexyz/world/src/System.sol";
import { ItemCreation, ItemCreationData } from "../codegen/index.sol";
import { ItemCreationCreated, ItemCreationUpdated } from "./ItemCreationEvents.sol";
import { ItemCreationCreateLogic } from "./ItemCreationCreateLogic.sol";
import { ItemCreationUpdateLogic } from "./ItemCreationUpdateLogic.sol";

contract ItemCreationSystem is System {
  event ItemCreationCreatedEvent(uint8 indexed ItemCreationIdSkillType, uint32 indexed ItemCreationIdItemId, uint16 requirementsLevel, uint32 baseQuantity, uint32 baseExperience, uint64 baseCreationTime, uint64 energyCost, uint16 successRate, uint32 resourceCost);

  event ItemCreationUpdatedEvent(uint8 indexed ItemCreationIdSkillType, uint32 indexed ItemCreationIdItemId, uint16 requirementsLevel, uint32 baseQuantity, uint32 baseExperience, uint64 baseCreationTime, uint64 energyCost, uint16 successRate, uint32 resourceCost);

  function itemCreationCreate(uint8 itemCreationIdSkillType, uint32 itemCreationIdItemId, uint16 requirementsLevel, uint32 baseQuantity, uint32 baseExperience, uint64 baseCreationTime, uint64 energyCost, uint16 successRate, uint32 resourceCost) public {
    ItemCreationData memory itemCreationData = ItemCreation.get(itemCreationIdSkillType, itemCreationIdItemId);
    require(
      itemCreationData.requirementsLevel == 0 && itemCreationData.baseQuantity == 0 && itemCreationData.baseExperience == 0 && itemCreationData.baseCreationTime == 0 && itemCreationData.energyCost == 0 && itemCreationData.successRate == 0 && itemCreationData.resourceCost == 0,
      "ItemCreation already exists"
    );
    ItemCreationCreated memory itemCreationCreated = ItemCreationCreateLogic.verify(itemCreationIdSkillType, itemCreationIdItemId, requirementsLevel, baseQuantity, baseExperience, baseCreationTime, energyCost, successRate, resourceCost);
    itemCreationCreated.ItemCreationIdSkillType = itemCreationIdSkillType;
    itemCreationCreated.ItemCreationIdItemId = itemCreationIdItemId;
    emit ItemCreationCreatedEvent(itemCreationCreated.ItemCreationIdSkillType, itemCreationCreated.ItemCreationIdItemId, itemCreationCreated.requirementsLevel, itemCreationCreated.baseQuantity, itemCreationCreated.baseExperience, itemCreationCreated.baseCreationTime, itemCreationCreated.energyCost, itemCreationCreated.successRate, itemCreationCreated.resourceCost);
    ItemCreationData memory newItemCreationData = ItemCreationCreateLogic.mutate(itemCreationCreated);
    ItemCreation.set(itemCreationIdSkillType, itemCreationIdItemId, newItemCreationData);
  }

  function itemCreationUpdate(uint8 itemCreationIdSkillType, uint32 itemCreationIdItemId, uint16 requirementsLevel, uint32 baseQuantity, uint32 baseExperience, uint64 baseCreationTime, uint64 energyCost, uint16 successRate, uint32 resourceCost) public {
    ItemCreationData memory itemCreationData = ItemCreation.get(itemCreationIdSkillType, itemCreationIdItemId);
    require(
      !(itemCreationData.requirementsLevel == 0 && itemCreationData.baseQuantity == 0 && itemCreationData.baseExperience == 0 && itemCreationData.baseCreationTime == 0 && itemCreationData.energyCost == 0 && itemCreationData.successRate == 0 && itemCreationData.resourceCost == 0),
      "ItemCreation does not exist"
    );
    ItemCreationUpdated memory itemCreationUpdated = ItemCreationUpdateLogic.verify(itemCreationIdSkillType, itemCreationIdItemId, requirementsLevel, baseQuantity, baseExperience, baseCreationTime, energyCost, successRate, resourceCost, itemCreationData);
    itemCreationUpdated.ItemCreationIdSkillType = itemCreationIdSkillType;
    itemCreationUpdated.ItemCreationIdItemId = itemCreationIdItemId;
    emit ItemCreationUpdatedEvent(itemCreationUpdated.ItemCreationIdSkillType, itemCreationUpdated.ItemCreationIdItemId, itemCreationUpdated.requirementsLevel, itemCreationUpdated.baseQuantity, itemCreationUpdated.baseExperience, itemCreationUpdated.baseCreationTime, itemCreationUpdated.energyCost, itemCreationUpdated.successRate, itemCreationUpdated.resourceCost);
    ItemCreationData memory updatedItemCreationData = ItemCreationUpdateLogic.mutate(itemCreationUpdated, itemCreationData);
    ItemCreation.set(itemCreationIdSkillType, itemCreationIdItemId, updatedItemCreationData);
  }

}