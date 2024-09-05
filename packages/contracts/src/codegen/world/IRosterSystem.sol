// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

/**
 * @title IRosterSystem
 * @author MUD (https://mud.dev) by Lattice (https://lattice.xyz)
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IRosterSystem {
  function app__rosterAdjustShipsPosition(
    uint256 playerId,
    uint32 sequenceNumber,
    uint64[] memory positions,
    uint256[] memory shipIds
  ) external;
}