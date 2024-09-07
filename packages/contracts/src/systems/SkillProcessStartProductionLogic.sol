// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ProductionProcessStarted } from "./SkillProcessEvents.sol";
import { SkillProcessData } from "../codegen/index.sol";

library SkillProcessStartProductionLogic {
  function verify(
    uint8 skillType,
    uint256 playerId,
    uint8 sequenceNumber,
    uint32 batchSize,
    uint32 itemId,
    SkillProcessData memory skillProcessData
  ) internal pure returns (ProductionProcessStarted memory) {
    // TODO ...
    //return ProductionProcessStarted(...);
  }

  function mutate(
    ProductionProcessStarted memory productionProcessStarted,
    SkillProcessData memory skillProcessData
  ) internal pure returns (SkillProcessData memory) {
    // TODO ...
  }
}
