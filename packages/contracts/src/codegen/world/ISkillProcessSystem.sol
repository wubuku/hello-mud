// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

/**
 * @title ISkillProcessSystem
 * @author MUD (https://mud.dev) by Lattice (https://lattice.xyz)
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface ISkillProcessSystem {
  function app__skillProcessCompleteProduction(uint8 skillType, uint256 playerId, uint8 sequenceNumber) external;

  function app__skillProcessCompleteShipProduction(uint8 skillType, uint256 playerId, uint8 sequenceNumber) external;

  function app__skillProcessCompleteCreation(uint8 skillType, uint256 playerId, uint8 sequenceNumber) external;

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
}
