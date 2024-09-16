// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { Roster, RosterData } from "../codegen/index.sol";
import { RosterCreated, RosterShipAdded, RosterSetSail } from "./RosterEvents.sol";
import { RosterCreateLogic } from "./RosterCreateLogic.sol";
import { RosterAddShipLogic } from "./RosterAddShipLogic.sol";
import { RosterSetSailLogic } from "./RosterSetSailLogic.sol";
import { SystemRegistry } from "@latticexyz/world/src/codegen/tables/SystemRegistry.sol";
import { NamespaceOwner } from "@latticexyz/world/src/codegen/tables/NamespaceOwner.sol";
import { ResourceId, WorldResourceIdInstance } from "@latticexyz/world/src/WorldResourceId.sol";
import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";

library RosterAggregateLib {
  using WorldResourceIdInstance for ResourceId;

  event RosterCreatedEvent(uint256 indexed playerId, uint32 indexed sequenceNumber);

  event RosterShipAddedEvent(uint256 indexed playerId, uint32 indexed sequenceNumber, uint256 shipId, uint64 position);

  event RosterSetSailEvent(uint256 indexed playerId, uint32 indexed sequenceNumber, int32 targetCoordinatesX, int32 targetCoordinatesY, uint64 sailDuration, uint64 setSailAt, int32 updatedCoordinatesX, int32 updatedCoordinatesY, uint64 energyCost);

  function _requireNamespaceOwner() internal view {
    ResourceId _thisSystemId = SystemRegistry.get(address(this));
    address _thisNamespaceOwner = NamespaceOwner.get(_thisSystemId.getNamespaceId());
    require(_thisNamespaceOwner == WorldContextConsumerLib._msgSender(), "Require namespace owner");
  }

  function create(uint256 playerId, uint32 sequenceNumber) internal returns (uint256, uint32, RosterData memory) {
    RosterData memory rosterData = Roster.get(playerId, sequenceNumber);
    require(
      !(rosterData.status == uint8(0) && rosterData.speed == uint32(0) && rosterData.coordinatesUpdatedAt == uint64(0) && rosterData.sailDuration == uint64(0) && rosterData.setSailAt == uint64(0) && rosterData.shipBattleId == uint256(0) && rosterData.environmentOwned == false && rosterData.baseExperience == uint32(0) && rosterData.shipIds.length == 0),
      "Roster does not exist"
    );
    RosterCreated memory rosterCreated = RosterCreateLogic.verify(playerId, sequenceNumber, rosterData);
    rosterCreated.playerId = playerId;
    rosterCreated.sequenceNumber = sequenceNumber;
    emit RosterCreatedEvent(rosterCreated.playerId, rosterCreated.sequenceNumber);
    RosterData memory updatedRosterData = RosterCreateLogic.mutate(rosterCreated, rosterData);
    Roster.set(playerId, sequenceNumber, updatedRosterData);
    return (playerId, sequenceNumber, updatedRosterData);
  }

  function addShip(uint256 playerId, uint32 sequenceNumber, uint256 shipId, uint64 position) internal {
    RosterData memory rosterData = Roster.get(playerId, sequenceNumber);
    require(
      !(rosterData.status == uint8(0) && rosterData.speed == uint32(0) && rosterData.coordinatesUpdatedAt == uint64(0) && rosterData.sailDuration == uint64(0) && rosterData.setSailAt == uint64(0) && rosterData.shipBattleId == uint256(0) && rosterData.environmentOwned == false && rosterData.baseExperience == uint32(0) && rosterData.shipIds.length == 0),
      "Roster does not exist"
    );
    RosterShipAdded memory rosterShipAdded = RosterAddShipLogic.verify(playerId, sequenceNumber, shipId, position, rosterData);
    rosterShipAdded.playerId = playerId;
    rosterShipAdded.sequenceNumber = sequenceNumber;
    emit RosterShipAddedEvent(rosterShipAdded.playerId, rosterShipAdded.sequenceNumber, rosterShipAdded.shipId, rosterShipAdded.position);
    RosterData memory updatedRosterData = RosterAddShipLogic.mutate(rosterShipAdded, rosterData);
    Roster.set(playerId, sequenceNumber, updatedRosterData);
  }

  function setSail(uint256 playerId, uint32 sequenceNumber, int32 targetCoordinatesX, int32 targetCoordinatesY, uint64 sailDuration, int32 updatedCoordinatesX, int32 updatedCoordinatesY) internal {
    RosterData memory rosterData = Roster.get(playerId, sequenceNumber);
    require(
      !(rosterData.status == uint8(0) && rosterData.speed == uint32(0) && rosterData.coordinatesUpdatedAt == uint64(0) && rosterData.sailDuration == uint64(0) && rosterData.setSailAt == uint64(0) && rosterData.shipBattleId == uint256(0) && rosterData.environmentOwned == false && rosterData.baseExperience == uint32(0) && rosterData.shipIds.length == 0),
      "Roster does not exist"
    );
    RosterSetSail memory rosterSetSail = RosterSetSailLogic.verify(playerId, sequenceNumber, targetCoordinatesX, targetCoordinatesY, sailDuration, updatedCoordinatesX, updatedCoordinatesY, rosterData);
    rosterSetSail.playerId = playerId;
    rosterSetSail.sequenceNumber = sequenceNumber;
    emit RosterSetSailEvent(rosterSetSail.playerId, rosterSetSail.sequenceNumber, rosterSetSail.targetCoordinatesX, rosterSetSail.targetCoordinatesY, rosterSetSail.sailDuration, rosterSetSail.setSailAt, rosterSetSail.updatedCoordinatesX, rosterSetSail.updatedCoordinatesY, rosterSetSail.energyCost);
    RosterData memory updatedRosterData = RosterSetSailLogic.mutate(rosterSetSail, rosterData);
    Roster.set(playerId, sequenceNumber, updatedRosterData);
  }

}
