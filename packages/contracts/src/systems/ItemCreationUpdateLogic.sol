// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ItemCreationUpdated } from "./ItemCreationEvents.sol";
import { ItemCreationData } from "../codegen/index.sol";

library ItemCreationUpdateLogic {
  function verify(
    uint8 skillType,
    uint32 itemId,
    uint16 requirementsLevel,
    uint32 baseQuantity,
    uint32 baseExperience,
    uint64 baseCreationTime,
    uint64 energyCost,
    uint16 successRate,
    uint32 resourceCost,
    ItemCreationData memory itemCreationData
  ) internal pure returns (ItemCreationUpdated memory) {
    return ItemCreationUpdated(skillType, itemId, requirementsLevel, baseQuantity, baseExperience, baseCreationTime, energyCost, successRate, resourceCost);
  }

  function mutate(
    ItemCreationUpdated memory itemCreationUpdated,
    ItemCreationData memory itemCreationData
  ) internal pure returns (ItemCreationData memory) {
    itemCreationData.requirementsLevel = itemCreationUpdated.requirementsLevel;
    itemCreationData.baseQuantity = itemCreationUpdated.baseQuantity;
    itemCreationData.baseExperience = itemCreationUpdated.baseExperience;
    itemCreationData.baseCreationTime = itemCreationUpdated.baseCreationTime;
    itemCreationData.energyCost = itemCreationUpdated.energyCost;
    itemCreationData.successRate = itemCreationUpdated.successRate;
    itemCreationData.resourceCost = itemCreationUpdated.resourceCost;
    return itemCreationData;
  }
}
