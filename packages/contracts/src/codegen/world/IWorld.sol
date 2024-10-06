// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";
import { IAggregatorServiceSystem } from "./IAggregatorServiceSystem.sol";
import { IArticleSystem } from "./IArticleSystem.sol";
import { ICounterSystem } from "./ICounterSystem.sol";
import { IEnergyTokenSystem } from "./IEnergyTokenSystem.sol";
import { IExperienceTableSystem } from "./IExperienceTableSystem.sol";
import { IIncrementSystem } from "./IIncrementSystem.sol";
import { IItemCreationSystem } from "./IItemCreationSystem.sol";
import { IItemProductionSystem } from "./IItemProductionSystem.sol";
import { IItemSystem } from "./IItemSystem.sol";
import { IMapFriendSystem } from "./IMapFriendSystem.sol";
import { IMapSystem } from "./IMapSystem.sol";
import { IPlayerFriendSystem } from "./IPlayerFriendSystem.sol";
import { IPlayerSystem } from "./IPlayerSystem.sol";
import { IPositionSystem } from "./IPositionSystem.sol";
import { IRosterFriendSystem } from "./IRosterFriendSystem.sol";
import { IRosterSailingSystem } from "./IRosterSailingSystem.sol";
import { IRosterShipInventorySystem } from "./IRosterShipInventorySystem.sol";
import { IRosterSystem } from "./IRosterSystem.sol";
import { IShipBattleInitiateSystem } from "./IShipBattleInitiateSystem.sol";
import { IShipBattleServiceSystem } from "./IShipBattleServiceSystem.sol";
import { IShipBattleSystem } from "./IShipBattleSystem.sol";
import { IShipBattleTakeLootSystem } from "./IShipBattleTakeLootSystem.sol";
import { IShipFriendSystem } from "./IShipFriendSystem.sol";
import { ISkillProcessFriendSystem } from "./ISkillProcessFriendSystem.sol";
import { ISkillProcessSystem } from "./ISkillProcessSystem.sol";
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
  IAggregatorServiceSystem,
  IArticleSystem,
  ICounterSystem,
  IEnergyTokenSystem,
  IExperienceTableSystem,
  IIncrementSystem,
  IItemCreationSystem,
  IItemProductionSystem,
  IItemSystem,
  IMapFriendSystem,
  IMapSystem,
  IPlayerFriendSystem,
  IPlayerSystem,
  IPositionSystem,
  IRosterFriendSystem,
  IRosterSailingSystem,
  IRosterShipInventorySystem,
  IRosterSystem,
  IShipBattleInitiateSystem,
  IShipBattleServiceSystem,
  IShipBattleSystem,
  IShipBattleTakeLootSystem,
  IShipFriendSystem,
  ISkillProcessFriendSystem,
  ISkillProcessSystem,
  ITerrainSystem
{}
