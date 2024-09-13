// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { System } from "@latticexyz/world/src/System.sol";
import { ItemProduction, ItemProductionData } from "../codegen/index.sol";
import { ItemProductionCreated, ItemProductionUpdated } from "./ItemProductionEvents.sol";
import { ItemProductionCreateLogic } from "./ItemProductionCreateLogic.sol";
import { ItemProductionUpdateLogic } from "./ItemProductionUpdateLogic.sol";

contract ItemProductionSystem is System {
  event ItemProductionCreatedEvent(uint8 indexed skillType, uint32 indexed itemId, uint16 requirementsLevel, uint32 baseQuantity, uint32 baseExperience, uint64 baseCreationTime, uint64 energyCost, uint16 successRate, uint32[] materialItemIds, uint32[] materialItemQuantities);

  event ItemProductionUpdatedEvent(uint8 indexed skillType, uint32 indexed itemId, uint16 requirementsLevel, uint32 baseQuantity, uint32 baseExperience, uint64 baseCreationTime, uint64 energyCost, uint16 successRate, uint32[] materialItemIds, uint32[] materialItemQuantities);

  function itemProductionCreate(uint8 skillType, uint32 itemId, uint16 requirementsLevel, uint32 baseQuantity, uint32 baseExperience, uint64 baseCreationTime, uint64 energyCost, uint16 successRate, uint32[] memory materialItemIds, uint32[] memory materialItemQuantities) public {
    ItemProductionData memory itemProductionData = ItemProduction.get(skillType, itemId);
    require(
      itemProductionData.requirementsLevel == uint16(0) && itemProductionData.baseQuantity == uint32(0) && itemProductionData.baseExperience == uint32(0) && itemProductionData.baseCreationTime == uint64(0) && itemProductionData.energyCost == uint64(0) && itemProductionData.successRate == uint16(0) && itemProductionData.materialItemIds.length == 0 && itemProductionData.materialItemQuantities.length == 0,
      "ItemProduction already exists"
    );
    ItemProductionCreated memory itemProductionCreated = ItemProductionCreateLogic.verify(skillType, itemId, requirementsLevel, baseQuantity, baseExperience, baseCreationTime, energyCost, successRate, materialItemIds, materialItemQuantities);
    itemProductionCreated.skillType = skillType;
    itemProductionCreated.itemId = itemId;
    emit ItemProductionCreatedEvent(itemProductionCreated.skillType, itemProductionCreated.itemId, itemProductionCreated.requirementsLevel, itemProductionCreated.baseQuantity, itemProductionCreated.baseExperience, itemProductionCreated.baseCreationTime, itemProductionCreated.energyCost, itemProductionCreated.successRate, itemProductionCreated.materialItemIds, itemProductionCreated.materialItemQuantities);
    ItemProductionData memory newItemProductionData = ItemProductionCreateLogic.mutate(itemProductionCreated);
    ItemProduction.set(skillType, itemId, newItemProductionData);
  }

  function itemProductionUpdate(uint8 skillType, uint32 itemId, uint16 requirementsLevel, uint32 baseQuantity, uint32 baseExperience, uint64 baseCreationTime, uint64 energyCost, uint16 successRate, uint32[] memory materialItemIds, uint32[] memory materialItemQuantities) public {
    ItemProductionData memory itemProductionData = ItemProduction.get(skillType, itemId);
    require(
      !(itemProductionData.requirementsLevel == uint16(0) && itemProductionData.baseQuantity == uint32(0) && itemProductionData.baseExperience == uint32(0) && itemProductionData.baseCreationTime == uint64(0) && itemProductionData.energyCost == uint64(0) && itemProductionData.successRate == uint16(0) && itemProductionData.materialItemIds.length == 0 && itemProductionData.materialItemQuantities.length == 0),
      "ItemProduction does not exist"
    );
    ItemProductionUpdated memory itemProductionUpdated = ItemProductionUpdateLogic.verify(skillType, itemId, requirementsLevel, baseQuantity, baseExperience, baseCreationTime, energyCost, successRate, materialItemIds, materialItemQuantities, itemProductionData);
    itemProductionUpdated.skillType = skillType;
    itemProductionUpdated.itemId = itemId;
    emit ItemProductionUpdatedEvent(itemProductionUpdated.skillType, itemProductionUpdated.itemId, itemProductionUpdated.requirementsLevel, itemProductionUpdated.baseQuantity, itemProductionUpdated.baseExperience, itemProductionUpdated.baseCreationTime, itemProductionUpdated.energyCost, itemProductionUpdated.successRate, itemProductionUpdated.materialItemIds, itemProductionUpdated.materialItemQuantities);
    ItemProductionData memory updatedItemProductionData = ItemProductionUpdateLogic.mutate(itemProductionUpdated, itemProductionData);
    ItemProduction.set(skillType, itemId, updatedItemProductionData);
  }

}
