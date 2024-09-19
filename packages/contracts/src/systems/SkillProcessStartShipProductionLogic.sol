// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ShipProductionProcessStarted } from "./SkillProcessEvents.sol";
import { SkillProcessData } from "../codegen/index.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";

library SkillProcessStartShipProductionLogic {
  function verify(
    uint8 skillType,
    uint256 playerId,
    uint8 sequenceNumber,
    uint32 itemId,
    ItemIdQuantityPair[] memory productionMaterials,
    SkillProcessData memory skillProcessData
  ) internal pure returns (ShipProductionProcessStarted memory) {
    // TODO ...
    //return ShipProductionProcessStarted(...);
  }

  function mutate(
    ShipProductionProcessStarted memory shipProductionProcessStarted,
    SkillProcessData memory skillProcessData
  ) internal pure returns (SkillProcessData memory) {
    // TODO ...
  }
}
