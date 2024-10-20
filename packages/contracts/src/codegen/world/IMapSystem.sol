// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { ItemIdQuantityPair } from "../../systems/ItemIdQuantityPair.sol";
import { Coordinates } from "../../systems/Coordinates.sol";

/**
 * @title IMapSystem
 * @author MUD (https://mud.dev) by Lattice (https://lattice.xyz)
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IMapSystem {
  function app__mapCreate(bool existing, bool islandClaimWhitelistEnabled) external;

  function app__mapUpdate(bool existing, bool islandClaimWhitelistEnabled) external;

  function app__mapAddIsland(uint32 coordinatesX, uint32 coordinatesY, ItemIdQuantityPair[] memory resources) external;

  function app__mapAddMultiIslands(
    Coordinates[] memory coordinates,
    uint32[] memory resourceItemIds,
    uint32 resourceSubtotal
  ) external;
}
