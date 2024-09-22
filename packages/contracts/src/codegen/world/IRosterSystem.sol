// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

/**
 * @title IRosterSystem
 * @author MUD (https://mud.dev) by Lattice (https://lattice.xyz)
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IRosterSystem {
  function app__rosterCreateEnvironmentRoster(
    uint256 playerId,
    uint32 sequenceNumber,
    uint32 coordinatesX,
    uint32 coordinatesY,
    uint32 shipResourceQuantity,
    uint32 shipBaseResourceQuantity,
    uint32 baseExperience
  ) external;

  function app__rosterAdjustShipsPosition(
    uint256 playerId,
    uint32 sequenceNumber,
    uint64[] memory positions,
    uint256[] memory shipIds
  ) external;

  function app__rosterTransferShip(
    uint256 playerId,
    uint32 sequenceNumber,
    uint256 shipId,
    uint256 toRosterPlayerId,
    uint32 toRosterSequenceNumber,
    uint64 toPosition
  ) external;
}
