// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

/**
 * @title IItemSystem
 * @author MUD (https://mud.dev) by Lattice (https://lattice.xyz)
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IItemSystem {
  function app__itemCreate(uint32 itemId, bool requiredForCompletion, uint32 sellsFor, string memory name) external;

  function app__itemUpdate(uint32 itemId, bool requiredForCompletion, uint32 sellsFor, string memory name) external;
}
