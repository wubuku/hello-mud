// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ItemCreationCreated } from "./ItemCreationEvents.sol";
import { ItemCreationData } from "../codegen/index.sol";

/**
 * @title ItemCreationCreateLogic Library
 * @dev Implements the ItemCreation.Create method.
 */
library ItemCreationCreateLogic {
  /**
   * @notice Verifies the ItemCreation.Create command.
   * @return A ItemCreationCreated event struct.
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
    uint32 resourceCost
  ) internal pure returns (ItemCreationCreated memory) {
    return ItemCreationCreated(skillType, itemId, requirementsLevel, baseQuantity, baseExperience, baseCreationTime, energyCost, successRate, resourceCost);
  }

  /**
   * @notice Performs the state mutation operation of ItemCreation.Create method.
   * @dev This function is called after verification to update the ItemCreation's state.
   * @param itemCreationCreated The ItemCreationCreated event struct from the verify function.
   * @return The new state of the ItemCreation.
   */
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
