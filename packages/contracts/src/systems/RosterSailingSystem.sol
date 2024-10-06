// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { System } from "@latticexyz/world/src/System.sol";
import { Roster, RosterData } from "../codegen/index.sol";
import { RosterSetSail } from "./RosterEvents.sol";
import { RosterSetSailLogic } from "./RosterSetSailLogic.sol";
import { Coordinates } from "./Coordinates.sol";
import { SystemRegistry } from "@latticexyz/world/src/codegen/tables/SystemRegistry.sol";
import { NamespaceOwner } from "@latticexyz/world/src/codegen/tables/NamespaceOwner.sol";
import { ResourceId, WorldResourceIdInstance } from "@latticexyz/world/src/WorldResourceId.sol";

contract RosterSailingSystem is System {
  using WorldResourceIdInstance for ResourceId;

  event RosterSetSailEvent(uint256 indexed playerId, uint32 indexed sequenceNumber, uint32 targetCoordinatesX, uint32 targetCoordinatesY, uint64 sailDuration, uint32 updatedCoordinatesX, uint32 updatedCoordinatesY, uint16 updatedSailSegment, uint64 setSailAt);

  function _requireNamespaceOwner() internal view {
    ResourceId _thisSystemId = SystemRegistry.get(address(this));
    address _thisNamespaceOwner = NamespaceOwner.get(_thisSystemId.getNamespaceId());
    require(_thisNamespaceOwner == _msgSender(), "Require namespace owner");
  }

  function rosterSetSail(uint256 playerId, uint32 sequenceNumber, uint32 targetCoordinatesX, uint32 targetCoordinatesY, uint64 sailDuration, uint32 updatedCoordinatesX, uint32 updatedCoordinatesY, uint16 updatedSailSegment, Coordinates[] memory intermediatePoints) public {
    RosterData memory rosterData = Roster.get(playerId, sequenceNumber);
    require(
      !(rosterData.status == uint8(0) && rosterData.speed == uint32(0) && rosterData.baseExperience == uint32(0) && rosterData.environmentOwned == false && rosterData.updatedCoordinatesX == uint32(0) && rosterData.updatedCoordinatesY == uint32(0) && rosterData.coordinatesUpdatedAt == uint64(0) && rosterData.targetCoordinatesX == uint32(0) && rosterData.targetCoordinatesY == uint32(0) && rosterData.originCoordinatesX == uint32(0) && rosterData.originCoordinatesY == uint32(0) && rosterData.sailDuration == uint64(0) && rosterData.setSailAt == uint64(0) && rosterData.currentSailSegment == uint16(0) && rosterData.shipBattleId == uint256(0) && rosterData.shipIds.length == 0),
      "Roster does not exist"
    );
    RosterSetSail memory rosterSetSail_e = RosterSetSailLogic.verify(playerId, sequenceNumber, targetCoordinatesX, targetCoordinatesY, sailDuration, updatedCoordinatesX, updatedCoordinatesY, updatedSailSegment, intermediatePoints, rosterData);
    rosterSetSail_e.playerId = playerId;
    rosterSetSail_e.sequenceNumber = sequenceNumber;
    emit RosterSetSailEvent(rosterSetSail_e.playerId, rosterSetSail_e.sequenceNumber, rosterSetSail_e.targetCoordinatesX, rosterSetSail_e.targetCoordinatesY, rosterSetSail_e.sailDuration, rosterSetSail_e.updatedCoordinatesX, rosterSetSail_e.updatedCoordinatesY, rosterSetSail_e.updatedSailSegment, rosterSetSail_e.setSailAt);
    RosterData memory updatedRosterData = RosterSetSailLogic.mutate(rosterSetSail_e, rosterData);
    Roster.set(playerId, sequenceNumber, updatedRosterData);
  }

}