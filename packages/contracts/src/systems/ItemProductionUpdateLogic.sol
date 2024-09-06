// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ItemProductionUpdated } from "./ItemProductionEvents.sol";
import { ItemProductionData } from "../codegen/index.sol";

library ItemProductionUpdateLogic {
  function verify(
    uint8 itemProductionIdSkillType,
    uint32 itemProductionIdItemId,
    uint16 requirementsLevel,
    uint32 baseQuantity,
    uint32 baseExperience,
    uint64 baseCreationTime,
    uint64 energyCost,
    uint16 successRate,
    uint32[] memory materialItemIds,
    uint32[] memory materialItemQuantities,
    ItemProductionData memory itemProductionData
  ) internal pure returns (ItemProductionUpdated memory) {
    return ItemProductionUpdated(itemProductionIdSkillType, itemProductionIdItemId, requirementsLevel, baseQuantity, baseExperience, baseCreationTime, energyCost, successRate, materialItemIds, materialItemQuantities);
  }

  function mutate(
    ItemProductionUpdated memory itemProductionUpdated,
    ItemProductionData memory itemProductionData
  ) internal pure returns (ItemProductionData memory) {
    // TODO ...
  }
}
