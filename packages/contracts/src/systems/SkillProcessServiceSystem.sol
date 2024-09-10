// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { System } from "@latticexyz/world/src/System.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";

contract SkillProcessServiceSystem is System {
  function skillProcessServiceStartCreation(uint8 skillProcessIdSkillType, uint256 skillProcessIdPlayerId, uint8 skillProcessIdSequenceNumber, uint32 batchSize, uint256 playerId, uint8 itemCreationIdSkillType, uint32 itemCreationIdItemId) public {
    // TODO ...
  }

  function skillProcessServiceStartProduction(uint8 skillProcessIdSkillType, uint256 skillProcessIdPlayerId, uint8 skillProcessIdSequenceNumber, uint32 batchSize, uint256 playerId, uint8 itemProductionIdSkillType, uint32 itemProductionIdItemId) public {
    // TODO ...
  }

  function skillProcessServiceStartShipProduction(uint8 skillProcessIdSkillType, uint256 skillProcessIdPlayerId, uint8 skillProcessIdSequenceNumber, ItemIdQuantityPair[] memory productionMaterials, uint256 playerId, uint8 itemProductionIdSkillType, uint32 itemProductionIdItemId) public {
    // TODO ...
  }

}
