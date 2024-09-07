// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ShipProductionProcessCompleted } from "./SkillProcessEvents.sol";
import { SkillProcessData } from "../codegen/index.sol";

library SkillProcessCompleteShipProductionLogic {
  function verify(
    uint8 skillType,
    uint256 playerId,
    uint8 sequenceNumber,
    SkillProcessData memory skillProcessData
  ) internal pure returns (ShipProductionProcessCompleted memory) {
    // TODO ...
    //return ShipProductionProcessCompleted(...);
  }

  function mutate(
    ShipProductionProcessCompleted memory shipProductionProcessCompleted,
    SkillProcessData memory skillProcessData
  ) internal pure returns (SkillProcessData memory) {
    // TODO ...
  }
}
