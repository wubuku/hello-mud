// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { ItemIdQuantityPair } from "../../systems/ItemIdQuantityPair.sol";

/**
 * @title ISkillProcessServiceSystem
 * @author MUD (https://mud.dev) by Lattice (https://lattice.xyz)
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface ISkillProcessServiceSystem {
  function app__skillProcessServiceStartCreation(
    uint8 skillProcessIdSkillType,
    uint256 skillProcessIdPlayerId,
    uint8 skillProcessIdSequenceNumber,
    uint32 batchSize,
    uint256 playerId,
    uint8 itemCreationIdSkillType,
    uint32 itemCreationIdItemId
  ) external;

  function app__skillProcessServiceStartProduction(
    uint8 skillProcessIdSkillType,
    uint256 skillProcessIdPlayerId,
    uint8 skillProcessIdSequenceNumber,
    uint32 batchSize,
    uint256 playerId,
    uint8 itemProductionIdSkillType,
    uint32 itemProductionIdItemId
  ) external;

  function app__skillProcessServiceStartShipProduction(
    uint8 skillProcessIdSkillType,
    uint256 skillProcessIdPlayerId,
    uint8 skillProcessIdSequenceNumber,
    ItemIdQuantityPair[] memory productionMaterials,
    uint256 playerId,
    uint8 itemProductionIdSkillType,
    uint32 itemProductionIdItemId
  ) external;
}