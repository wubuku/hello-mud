// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { ItemIdQuantityPair } from "../../systems/ItemIdQuantityPair.sol";

/**
 * @title ISkillProcessFriendSystem
 * @author MUD (https://mud.dev) by Lattice (https://lattice.xyz)
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface ISkillProcessFriendSystem {
  function app__skillProcessCreate(
    uint8 skillType,
    uint256 playerId,
    uint8 sequenceNumber,
    uint32 itemId,
    uint64 startedAt,
    uint64 creationTime,
    bool completed,
    uint64 endedAt,
    uint32 batchSize
  ) external;

  function app__skillProcessStartProduction(
    uint8 skillType,
    uint256 playerId,
    uint8 sequenceNumber,
    uint32 batchSize,
    uint32 itemId
  ) external;

  function app__skillProcessStartShipProduction(
    uint8 skillType,
    uint256 playerId,
    uint8 sequenceNumber,
    ItemIdQuantityPair[] memory productionMaterials,
    uint32 itemId
  ) external;

  function app__skillProcessStartCreation(
    uint8 skillType,
    uint256 playerId,
    uint8 sequenceNumber,
    uint32 batchSize,
    uint32 itemId
  ) external;
}
