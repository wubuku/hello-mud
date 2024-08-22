// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

/**
 * @title IPositionSystem
 * @author MUD (https://mud.dev) by Lattice (https://lattice.xyz)
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IPositionSystem {
  function app__positionCreate(address player, int32 x, int32 y, string memory description) external;

  function app__positionUpdate(address player, int32 x, int32 y, string memory description) external;
}
