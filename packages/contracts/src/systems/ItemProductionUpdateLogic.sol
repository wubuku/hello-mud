// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ItemProductionUpdated } from "./ItemProductionEvents.sol";
import { ItemProductionData } from "../codegen/index.sol";

/**
 * @title ItemProductionUpdateLogic Library
 * @dev Implements the ItemProduction.Update method.
 */
library ItemProductionUpdateLogic {
  /**
   * @notice Verifies the ItemProduction.Update command.
   * @param itemProductionData The current state the ItemProduction.
   * @return A ItemProductionUpdated event struct.
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
    uint32[] memory materialItemQuantities,
    ItemProductionData memory itemProductionData
  ) internal pure returns (ItemProductionUpdated memory) {
    return ItemProductionUpdated(skillType, itemId, requirementsLevel, baseQuantity, baseExperience, baseCreationTime, energyCost, successRate, materialItemIds, materialItemQuantities);
  }

  /**
   * @notice Performs the state mutation operation of ItemProduction.Update method.
   * @dev This function is called after verification to update the ItemProduction's state.
   * @param itemProductionUpdated The ItemProductionUpdated event struct from the verify function.
   * @param itemProductionData The current state of the ItemProduction.
   * @return The new state of the ItemProduction.
   */
  function mutate(
    ItemProductionUpdated memory itemProductionUpdated,
    ItemProductionData memory itemProductionData
  ) internal pure returns (ItemProductionData memory) {
    itemProductionData.requirementsLevel = itemProductionUpdated.requirementsLevel;
    itemProductionData.baseQuantity = itemProductionUpdated.baseQuantity;
    itemProductionData.baseExperience = itemProductionUpdated.baseExperience;
    itemProductionData.baseCreationTime = itemProductionUpdated.baseCreationTime;
    itemProductionData.energyCost = itemProductionUpdated.energyCost;
    itemProductionData.successRate = itemProductionUpdated.successRate;
    itemProductionData.materialItemIds = itemProductionUpdated.materialItemIds;
    itemProductionData.materialItemQuantities = itemProductionUpdated.materialItemQuantities;
    return itemProductionData;
  }
}
