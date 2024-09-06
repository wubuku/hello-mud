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
    // TODO ...
    //return ItemCreationCreated(...);
  }

  function mutate(
    ItemCreationCreated memory itemCreationCreated
  ) internal pure returns (ItemCreationData memory) {
    // TODO ...
  }
}
