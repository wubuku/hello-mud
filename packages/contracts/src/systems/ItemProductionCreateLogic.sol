// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ItemProductionCreated } from "./ItemProductionEvents.sol";
import { ItemProductionData } from "../codegen/index.sol";

/**
 * @title ItemProductionCreateLogic Library
 * @dev Implements the ItemProduction.Create method.
 */
library ItemProductionCreateLogic {
  /**
   * @notice Verifies the ItemProduction.Create command.
   * @return A ItemProductionCreated event struct.
   */
  function verify(
    uint8 skillType,
    uint32 itemId,
    uint16 requirementsLevel,
    uint32 baseQuantity,
    uint32 baseExperience,
    uint64 baseCreationTime,
    uint64 energyCost,
    uint16 successRate,
    uint32[] memory materialItemIds,
    uint32[] memory materialItemQuantities
  ) internal pure returns (ItemProductionCreated memory) {
    return ItemProductionCreated(skillType, itemId, requirementsLevel, baseQuantity, baseExperience, baseCreationTime, energyCost, successRate, materialItemIds, materialItemQuantities);
  }

  /**
   * @notice Performs the state mutation operation of ItemProduction.Create method.
   * @dev This function is called after verification to update the ItemProduction's state.
   * @param itemProductionCreated The ItemProductionCreated event struct from the verify function.
   * @return The new state of the ItemProduction.
   */
  function mutate(
    ItemProductionCreated memory itemProductionCreated
  ) internal pure returns (ItemProductionData memory) {
    ItemProductionData memory itemProductionData;
    itemProductionData.requirementsLevel = itemProductionCreated.requirementsLevel;
    itemProductionData.baseQuantity = itemProductionCreated.baseQuantity;
    itemProductionData.baseExperience = itemProductionCreated.baseExperience;
    itemProductionData.baseCreationTime = itemProductionCreated.baseCreationTime;
    itemProductionData.energyCost = itemProductionCreated.energyCost;
    itemProductionData.successRate = itemProductionCreated.successRate;
    itemProductionData.materialItemIds = itemProductionCreated.materialItemIds;
    itemProductionData.materialItemQuantities = itemProductionCreated.materialItemQuantities;
    return itemProductionData;
  }
}
