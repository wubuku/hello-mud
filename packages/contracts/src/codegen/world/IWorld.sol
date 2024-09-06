// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";
import { IArticleSystem } from "./IArticleSystem.sol";
import { ICounterSystem } from "./ICounterSystem.sol";
import { IIncrementSystem } from "./IIncrementSystem.sol";
import { IMapSystem } from "./IMapSystem.sol";
import { IPlayerSystem } from "./IPlayerSystem.sol";
import { IPositionSystem } from "./IPositionSystem.sol";
import { IRosterSystem } from "./IRosterSystem.sol";
import { IShipBattleSystem } from "./IShipBattleSystem.sol";
import { IShipSystem } from "./IShipSystem.sol";
import { ITerrainSystem } from "./ITerrainSystem.sol";

/**
 * @title IWorld
 * @author MUD (https://mud.dev) by Lattice (https://lattice.xyz)
 * @notice This interface integrates all systems and associated function selectors
 * that are dynamically registered in the World during deployment.
 * @dev This is an autogenerated file; do not edit manually.
 */
interface IWorld is
  IBaseWorld,
  IArticleSystem,
  ICounterSystem,
  IIncrementSystem,
  IMapSystem,
  IPlayerSystem,
  IPositionSystem,
  IRosterSystem,
  IShipBattleSystem,
  IShipSystem,
  ITerrainSystem
{}
