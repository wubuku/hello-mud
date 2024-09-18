// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

/**
 * @title IShipFriendSystem
 * @author MUD (https://mud.dev) by Lattice (https://lattice.xyz)
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IShipFriendSystem {
  function app__shipCreate(
    uint256 rosterIdPlayerId,
    uint32 rosterIdSequenceNumber,
    uint32 healthPoints,
    uint32 attack,
    uint32 protection,
    uint32 speed,
    uint32[] memory buildingExpensesItemIds,
    uint32[] memory buildingExpensesQuantities
  ) external returns (uint256);
}
