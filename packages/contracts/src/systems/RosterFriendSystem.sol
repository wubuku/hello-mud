// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { System } from "@latticexyz/world/src/System.sol";
import { Roster, RosterData } from "../codegen/index.sol";
import { RosterCreated, RosterShipAdded } from "./RosterEvents.sol";
import { RosterCreateLogic } from "./RosterCreateLogic.sol";
import { RosterAddShipLogic } from "./RosterAddShipLogic.sol";
import { SystemRegistry } from "@latticexyz/world/src/codegen/tables/SystemRegistry.sol";
import { NamespaceOwner } from "@latticexyz/world/src/codegen/tables/NamespaceOwner.sol";
import { ResourceId, WorldResourceIdInstance } from "@latticexyz/world/src/WorldResourceId.sol";

contract RosterFriendSystem is System {
  using WorldResourceIdInstance for ResourceId;

  event RosterCreatedEvent(uint256 indexed playerId, uint32 indexed sequenceNumber, uint32 coordinatesX, uint32 coordinatesY);

  event RosterShipAddedEvent(uint256 indexed playerId, uint32 indexed sequenceNumber, uint256 shipId, uint64 position);

  function _requireNamespaceOwner() internal view {
    ResourceId _thisSystemId = SystemRegistry.get(address(this));
    address _thisNamespaceOwner = NamespaceOwner.get(_thisSystemId.getNamespaceId());
    require(_thisNamespaceOwner == _msgSender(), "Require namespace owner");
  }

  function rosterCreate(uint256 playerId, uint32 sequenceNumber, uint32 coordinatesX, uint32 coordinatesY) public returns (uint256, uint32) {
    RosterData memory rosterData = Roster.get(playerId, sequenceNumber);
    require(
      rosterData.status == uint8(0) && rosterData.speed == uint32(0) && rosterData.baseExperience == uint32(0) && rosterData.environmentOwned == false && rosterData.updatedCoordinatesX == uint32(0) && rosterData.updatedCoordinatesY == uint32(0) && rosterData.coordinatesUpdatedAt == uint64(0) && rosterData.targetCoordinatesX == uint32(0) && rosterData.targetCoordinatesY == uint32(0) && rosterData.originCoordinatesX == uint32(0) && rosterData.originCoordinatesY == uint32(0) && rosterData.sailDuration == uint64(0) && rosterData.setSailAt == uint64(0) && rosterData.currentSailSegment == uint16(0) && rosterData.shipBattleId == uint256(0) && rosterData.shipIds.length == 0,
      "Roster already exists"
    );
    RosterCreated memory rosterCreated = RosterCreateLogic.verify(playerId, sequenceNumber, coordinatesX, coordinatesY);
    rosterCreated.playerId = playerId;
    rosterCreated.sequenceNumber = sequenceNumber;
    emit RosterCreatedEvent(rosterCreated.playerId, rosterCreated.sequenceNumber, rosterCreated.coordinatesX, rosterCreated.coordinatesY);
    RosterData memory newRosterData = RosterCreateLogic.mutate(rosterCreated);
    Roster.set(playerId, sequenceNumber, newRosterData);
    return (playerId, sequenceNumber);
  }

  function rosterAddShip(uint256 playerId, uint32 sequenceNumber, uint256 shipId, uint64 position) public {
    RosterData memory rosterData = Roster.get(playerId, sequenceNumber);
    require(
      !(rosterData.status == uint8(0) && rosterData.speed == uint32(0) && rosterData.baseExperience == uint32(0) && rosterData.environmentOwned == false && rosterData.updatedCoordinatesX == uint32(0) && rosterData.updatedCoordinatesY == uint32(0) && rosterData.coordinatesUpdatedAt == uint64(0) && rosterData.targetCoordinatesX == uint32(0) && rosterData.targetCoordinatesY == uint32(0) && rosterData.originCoordinatesX == uint32(0) && rosterData.originCoordinatesY == uint32(0) && rosterData.sailDuration == uint64(0) && rosterData.setSailAt == uint64(0) && rosterData.currentSailSegment == uint16(0) && rosterData.shipBattleId == uint256(0) && rosterData.shipIds.length == 0),
      "Roster does not exist"
    );
    RosterShipAdded memory rosterShipAdded = RosterAddShipLogic.verify(playerId, sequenceNumber, shipId, position, rosterData);
    rosterShipAdded.playerId = playerId;
    rosterShipAdded.sequenceNumber = sequenceNumber;
    emit RosterShipAddedEvent(rosterShipAdded.playerId, rosterShipAdded.sequenceNumber, rosterShipAdded.shipId, rosterShipAdded.position);
    RosterData memory updatedRosterData = RosterAddShipLogic.mutate(rosterShipAdded, rosterData);
    Roster.set(playerId, sequenceNumber, updatedRosterData);
  }

}
