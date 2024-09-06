// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ItemCreationUpdated } from "./ItemCreationEvents.sol";
import { ItemCreationData } from "../codegen/index.sol";

library ItemCreationUpdateLogic {
  function verify(
    uint8 itemCreationIdSkillType,
    uint32 itemCreationIdItemId,
    uint16 requirementsLevel,
    uint32 baseQuantity,
    uint32 baseExperience,
    uint64 baseCreationTime,
    uint64 energyCost,
    uint16 successRate,
    uint32 resourceCost,
    ItemCreationData memory itemCreationData
  ) internal pure returns (ItemCreationUpdated memory) {
    // TODO ...
    //return ItemCreationUpdated(...);
  }

  function mutate(
    ItemCreationUpdated memory itemCreationUpdated,
    ItemCreationData memory itemCreationData
  ) internal pure returns (ItemCreationData memory) {
    // TODO ...
  }
}