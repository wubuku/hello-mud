// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ItemCreationCreated } from "./ItemCreationEvents.sol";
import { ItemCreationData } from "../codegen/index.sol";

library ItemCreationCreateLogic {
  function verify(
    uint8 itemCreationIdSkillType,
    uint32 itemCreationIdItemId,
    uint16 requirementsLevel,
    uint32 baseQuantity,
    uint32 baseExperience,
    uint64 baseCreationTime,
    uint64 energyCost,
    uint16 successRate,
    uint32 resourceCost
  ) internal pure returns (ItemCreationCreated memory) {
    return ItemCreationCreated(itemCreationIdSkillType, itemCreationIdItemId, requirementsLevel, baseQuantity, baseExperience, baseCreationTime, energyCost, successRate, resourceCost);
  }

  function mutate(
    ItemCreationCreated memory itemCreationCreated
  ) internal pure returns (ItemCreationData memory) {
    ItemCreationData memory itemCreationData;
    itemCreationData.requirementsLevel = itemCreationCreated.requirementsLevel;
    itemCreationData.baseQuantity = itemCreationCreated.baseQuantity;
    itemCreationData.baseExperience = itemCreationCreated.baseExperience;
    itemCreationData.baseCreationTime = itemCreationCreated.baseCreationTime;
    itemCreationData.energyCost = itemCreationCreated.energyCost;
    itemCreationData.successRate = itemCreationCreated.successRate;
    itemCreationData.resourceCost = itemCreationCreated.resourceCost;
    return itemCreationData;
  }
}
