// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { DelegationControl } from "@latticexyz/world/src/DelegationControl.sol";
import { ResourceId } from "@latticexyz/world/src/WorldResourceId.sol";
import { RESOURCE_SYSTEM } from "@latticexyz/world/src/worldResourceTypes.sol";
import { SystemRegistry } from "@latticexyz/world/src/codegen/tables/SystemRegistry.sol";

contract AppFriendDelegationControl is DelegationControl {
  ResourceId constant PLAYER_SYSTEM =
    ResourceId.wrap(bytes32(abi.encodePacked(RESOURCE_SYSTEM, bytes14("app"), bytes16("PlayerSystem"))));

  ResourceId constant PLAYER_FRIEND_SYSTEM =
    ResourceId.wrap(
      bytes32(abi.encodePacked(RESOURCE_SYSTEM, bytes14("app"), bytes16(bytes("PlayerFriendSystem"))))
      // NOTE: Only 16 bytes are used: "PlayerFriendSyst"
    );

  ResourceId constant SKILL_PROCESS_SYSTEM =
    ResourceId.wrap(
      bytes32(abi.encodePacked(RESOURCE_SYSTEM, bytes14("app"), bytes16(bytes("SkillProcessSystem"))))
      // NOTE: Only 16 bytes are used: "SkillProcessSyst"
    );

  ResourceId constant ROSTER_SHIP_INVENTORY_SYSTEM =
    ResourceId.wrap(
      bytes32(abi.encodePacked(RESOURCE_SYSTEM, bytes14("app"), bytes16(bytes("RosterShipInventorySystem"))))
      // NOTE: Only 16 bytes are used: "RosterShipInvent"
    );

  ResourceId constant SHIP_FRIEND_SYSTEM =
    ResourceId.wrap(bytes32(abi.encodePacked(RESOURCE_SYSTEM, bytes14("app"), bytes16("ShipFriendSystem"))));

  ResourceId constant ROSTER_SYSTEM =
    ResourceId.wrap(bytes32(abi.encodePacked(RESOURCE_SYSTEM, bytes14("app"), bytes16("RosterSystem"))));

  ResourceId constant SHIP_BATTLE_TAKE_LOOT_SYSTEM =
    ResourceId.wrap(
      bytes32(abi.encodePacked(RESOURCE_SYSTEM, bytes14("app"), bytes16(bytes("ShipBattleTakeLootSystem"))))
      // NOTE: Only 16 bytes are used: "ShipBattleTakeLo"
    );

  ResourceId constant ROSTER_FRIEND_SYSTEM =
    ResourceId.wrap(
      bytes32(abi.encodePacked(RESOURCE_SYSTEM, bytes14("app"), bytes16(bytes("RosterFriendSystem"))))
      // NOTE: Only 16 bytes are used: "RosterFriendSyst"
    );

  ResourceId constant ROSTER_SAILING_SYSTEM =
    ResourceId.wrap(
      bytes32(abi.encodePacked(RESOURCE_SYSTEM, bytes14("app"), bytes16(bytes("RosterSailingSystem"))))
      // NOTE: Only 16 bytes are used: "RosterSailingSys"
    );

  ResourceId constant ROSTER_CLEANING_SYSTEM =
    ResourceId.wrap(
      bytes32(abi.encodePacked(RESOURCE_SYSTEM, bytes14("app"), bytes16(bytes("RosterCleaningSystem"))))
      // NOTE: Only 16 bytes are used: "RosterCleaningSy"
    );

  ResourceId constant SHIP_BATTLE_INITIATE_SYSTEM =
    ResourceId.wrap(
      bytes32(abi.encodePacked(RESOURCE_SYSTEM, bytes14("app"), bytes16(bytes("ShipBattleInitiateSystem"))))
      // NOTE: Only 16 bytes are used: "ShipBattleInitia"
    );

  ResourceId constant SHIP_BATTLE_SYSTEM =
    ResourceId.wrap(bytes32(abi.encodePacked(RESOURCE_SYSTEM, bytes14("app"), bytes16("ShipBattleSystem"))));

  ResourceId constant AGGREGATOR_SERVICE_SYSTEM =
    ResourceId.wrap(
      bytes32(abi.encodePacked(RESOURCE_SYSTEM, bytes14("app"), bytes16(bytes("AggregatorServiceSystem"))))
      // NOTE: Only 16 bytes are used: "AggregatorServic"
    );

  ResourceId constant SHIP_BATTLE_SERVICE_SYSTEM =
    ResourceId.wrap(
      bytes32(abi.encodePacked(RESOURCE_SYSTEM, bytes14("app"), bytes16(bytes("ShipBattleServiceSystem"))))
      // NOTE: Only 16 bytes are used: "ShipBattleServic"
    );

  ResourceId constant SKILL_PROCESS_FRIEND_SYSTEM =
    ResourceId.wrap(
      bytes32(abi.encodePacked(RESOURCE_SYSTEM, bytes14("app"), bytes16(bytes("SkillProcessFriendSystem"))))
      // NOTE: Only 16 bytes are used: "SkillProcessFrie"
    );

  ResourceId constant MAP_SYSTEM =
    ResourceId.wrap(bytes32(abi.encodePacked(RESOURCE_SYSTEM, bytes14("app"), bytes16("MapSystem"))));

  ResourceId constant MAP_FRIEND_SYSTEM =
    ResourceId.wrap(bytes32(abi.encodePacked(RESOURCE_SYSTEM, bytes14("app"), bytes16("MapFriendSystem"))));

  function verify(address /*delegator*/, ResourceId systemId, bytes memory /*callData*/) public view returns (bool) {
    ResourceId callerSystemId = SystemRegistry.get(_msgSender());
    return
      ResourceId.unwrap(systemId) == ResourceId.unwrap(PLAYER_SYSTEM) &&
      (
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(SKILL_PROCESS_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(ROSTER_SHIP_INVENTORY_SYSTEM)
      ) ||
      ResourceId.unwrap(systemId) == ResourceId.unwrap(PLAYER_FRIEND_SYSTEM) &&
      (
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(SKILL_PROCESS_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(ROSTER_SHIP_INVENTORY_SYSTEM)
      ) ||
      ResourceId.unwrap(systemId) == ResourceId.unwrap(SHIP_FRIEND_SYSTEM) &&
      (
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(SKILL_PROCESS_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(ROSTER_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(SHIP_BATTLE_TAKE_LOOT_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(ROSTER_SHIP_INVENTORY_SYSTEM)
      ) ||
      ResourceId.unwrap(systemId) == ResourceId.unwrap(ROSTER_FRIEND_SYSTEM) &&
      (
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(PLAYER_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(SHIP_BATTLE_INITIATE_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(SHIP_BATTLE_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(SHIP_BATTLE_TAKE_LOOT_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(SKILL_PROCESS_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(AGGREGATOR_SERVICE_SYSTEM)
      ) ||
      ResourceId.unwrap(systemId) == ResourceId.unwrap(ROSTER_SYSTEM) &&
      (
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(PLAYER_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(SHIP_BATTLE_INITIATE_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(SHIP_BATTLE_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(SHIP_BATTLE_TAKE_LOOT_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(SKILL_PROCESS_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(AGGREGATOR_SERVICE_SYSTEM)
      ) ||
      ResourceId.unwrap(systemId) == ResourceId.unwrap(ROSTER_SAILING_SYSTEM) &&
      (
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(PLAYER_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(SHIP_BATTLE_INITIATE_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(SHIP_BATTLE_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(SHIP_BATTLE_TAKE_LOOT_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(SKILL_PROCESS_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(AGGREGATOR_SERVICE_SYSTEM)
      ) ||
      ResourceId.unwrap(systemId) == ResourceId.unwrap(ROSTER_CLEANING_SYSTEM) &&
      (
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(PLAYER_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(SHIP_BATTLE_INITIATE_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(SHIP_BATTLE_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(SHIP_BATTLE_TAKE_LOOT_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(SKILL_PROCESS_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(AGGREGATOR_SERVICE_SYSTEM)
      ) ||
      ResourceId.unwrap(systemId) == ResourceId.unwrap(ROSTER_SHIP_INVENTORY_SYSTEM) &&
      (
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(PLAYER_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(SHIP_BATTLE_INITIATE_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(SHIP_BATTLE_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(SHIP_BATTLE_TAKE_LOOT_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(SKILL_PROCESS_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(AGGREGATOR_SERVICE_SYSTEM)
      ) ||
      ResourceId.unwrap(systemId) == ResourceId.unwrap(SHIP_BATTLE_INITIATE_SYSTEM) &&
      (
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(SHIP_BATTLE_SERVICE_SYSTEM)
      ) ||
      ResourceId.unwrap(systemId) == ResourceId.unwrap(SHIP_BATTLE_SYSTEM) &&
      (
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(SHIP_BATTLE_SERVICE_SYSTEM)
      ) ||
      ResourceId.unwrap(systemId) == ResourceId.unwrap(SHIP_BATTLE_TAKE_LOOT_SYSTEM) &&
      (
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(SHIP_BATTLE_SERVICE_SYSTEM)
      ) ||
      ResourceId.unwrap(systemId) == ResourceId.unwrap(SKILL_PROCESS_FRIEND_SYSTEM) &&
      (
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(PLAYER_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(AGGREGATOR_SERVICE_SYSTEM)
      ) ||
      ResourceId.unwrap(systemId) == ResourceId.unwrap(SKILL_PROCESS_SYSTEM) &&
      (
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(PLAYER_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(AGGREGATOR_SERVICE_SYSTEM)
      ) ||
      ResourceId.unwrap(systemId) == ResourceId.unwrap(MAP_SYSTEM) &&
      (
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(PLAYER_SYSTEM)
      ) ||
      ResourceId.unwrap(systemId) == ResourceId.unwrap(MAP_FRIEND_SYSTEM) &&
      (
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(PLAYER_SYSTEM)
      );
  }
}
