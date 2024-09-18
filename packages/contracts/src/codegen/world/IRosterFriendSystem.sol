// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

/**
 * @title IRosterFriendSystem
 * @author MUD (https://mud.dev) by Lattice (https://lattice.xyz)
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IRosterFriendSystem {
  function app__rosterCreate(uint256 playerId, uint32 sequenceNumber) external returns (uint256, uint32);

  function app__rosterAddShip(uint256 playerId, uint32 sequenceNumber, uint256 shipId, uint64 position) external;
}
