// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ProductionProcessCompleted } from "./SkillProcessEvents.sol";
import { SkillProcessData } from "../codegen/index.sol";

library SkillProcessCompleteProductionLogic {
  function verify(
    uint8 skillType,
    uint256 playerId,
    uint8 sequenceNumber,
    SkillProcessData memory skillProcessData
  ) internal pure returns (ProductionProcessCompleted memory) {
    // TODO ...
    //return ProductionProcessCompleted(...);
  }

  function mutate(
    ProductionProcessCompleted memory productionProcessCompleted,
    SkillProcessData memory skillProcessData
  ) internal pure returns (SkillProcessData memory) {
    // TODO ...
  }
}
