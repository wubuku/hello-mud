// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { System } from "@latticexyz/world/src/System.sol";
import { Roster, RosterData } from "../codegen/index.sol";
import { EnvironmentRosterCreated, RosterShipsPositionAdjusted, RosterShipTransferred, RosterMultiShipsTransferred } from "./RosterEvents.sol";
import { RosterCreateEnvironmentRosterLogic } from "./RosterCreateEnvironmentRosterLogic.sol";
import { RosterAdjustShipsPositionLogic } from "./RosterAdjustShipsPositionLogic.sol";
import { RosterTransferShipLogic } from "./RosterTransferShipLogic.sol";
import { RosterTransferMultiShipsLogic } from "./RosterTransferMultiShipsLogic.sol";
import { SystemRegistry } from "@latticexyz/world/src/codegen/tables/SystemRegistry.sol";
import { NamespaceOwner } from "@latticexyz/world/src/codegen/tables/NamespaceOwner.sol";
import { ResourceId, WorldResourceIdInstance } from "@latticexyz/world/src/WorldResourceId.sol";
import { IAppSystemErrors } from "./IAppSystemErrors.sol";

contract RosterSystem is System, IAppSystemErrors {
  using WorldResourceIdInstance for ResourceId;

  event EnvironmentRosterCreatedEvent(uint256 indexed playerId, uint32 indexed sequenceNumber, uint32 coordinatesX, uint32 coordinatesY, uint32 shipResourceQuantity, uint32 shipBaseResourceQuantity, uint32 baseExperience);

  event RosterShipsPositionAdjustedEvent(uint256 indexed playerId, uint32 indexed sequenceNumber, uint64[] positions, uint256[] shipIds);

  event RosterShipTransferredEvent(uint256 indexed playerId, uint32 indexed sequenceNumber, uint256 shipId, uint256 toRosterPlayerId, uint32 toRosterSequenceNumber, uint64 toPosition, uint64 transferredAt);

  event RosterMultiShipsTransferredEvent(uint256 indexed playerId, uint32 indexed sequenceNumber, uint256[] shipIds, uint256 toRosterPlayerId, uint32 toRosterSequenceNumber, uint64 toPosition, uint64 transferredAt);

  function _requireNamespaceOwner() internal view {
    ResourceId _thisSystemId = SystemRegistry.get(address(this));
    address _thisNamespaceOwner = NamespaceOwner.get(_thisSystemId.getNamespaceId());
    if (_thisNamespaceOwner != _msgSender()) {
      revert RequireNamespaceOwner(_msgSender(), _thisNamespaceOwner);
    }
  }

  function rosterCreateEnvironmentRoster(uint256 playerId, uint32 sequenceNumber, uint32 coordinatesX, uint32 coordinatesY, uint32 shipResourceQuantity, uint32 shipBaseResourceQuantity, uint32 baseExperience) public {
    _requireNamespaceOwner();
    RosterData memory rosterData = Roster.get(playerId, sequenceNumber);
    if (!(rosterData.status == uint8(0) && rosterData.speed == uint32(0) && rosterData.baseExperience == uint32(0) && rosterData.environmentOwned == false && rosterData.updatedCoordinatesX == uint32(0) && rosterData.updatedCoordinatesY == uint32(0) && rosterData.coordinatesUpdatedAt == uint64(0) && rosterData.targetCoordinatesX == uint32(0) && rosterData.targetCoordinatesY == uint32(0) && rosterData.originCoordinatesX == uint32(0) && rosterData.originCoordinatesY == uint32(0) && rosterData.sailDuration == uint64(0) && rosterData.setSailAt == uint64(0) && rosterData.currentSailSegment == uint16(0) && rosterData.shipBattleId == uint256(0) && rosterData.shipIds.length == 0)) {
      revert RosterAlreadyExists(playerId, sequenceNumber);
    }
    EnvironmentRosterCreated memory environmentRosterCreated = RosterCreateEnvironmentRosterLogic.verify(playerId, sequenceNumber, coordinatesX, coordinatesY, shipResourceQuantity, shipBaseResourceQuantity, baseExperience);
    environmentRosterCreated.playerId = playerId;
    environmentRosterCreated.sequenceNumber = sequenceNumber;
    emit EnvironmentRosterCreatedEvent(environmentRosterCreated.playerId, environmentRosterCreated.sequenceNumber, environmentRosterCreated.coordinatesX, environmentRosterCreated.coordinatesY, environmentRosterCreated.shipResourceQuantity, environmentRosterCreated.shipBaseResourceQuantity, environmentRosterCreated.baseExperience);
    RosterData memory newRosterData = RosterCreateEnvironmentRosterLogic.mutate(environmentRosterCreated);
    Roster.set(playerId, sequenceNumber, newRosterData);
  }

  function rosterAdjustShipsPosition(uint256 playerId, uint32 sequenceNumber, uint64[] memory positions, uint256[] memory shipIds) public {
    RosterData memory rosterData = Roster.get(playerId, sequenceNumber);
    if (rosterData.status == uint8(0) && rosterData.speed == uint32(0) && rosterData.baseExperience == uint32(0) && rosterData.environmentOwned == false && rosterData.updatedCoordinatesX == uint32(0) && rosterData.updatedCoordinatesY == uint32(0) && rosterData.coordinatesUpdatedAt == uint64(0) && rosterData.targetCoordinatesX == uint32(0) && rosterData.targetCoordinatesY == uint32(0) && rosterData.originCoordinatesX == uint32(0) && rosterData.originCoordinatesY == uint32(0) && rosterData.sailDuration == uint64(0) && rosterData.setSailAt == uint64(0) && rosterData.currentSailSegment == uint16(0) && rosterData.shipBattleId == uint256(0) && rosterData.shipIds.length == 0) {
      revert RosterDoesNotExist(playerId, sequenceNumber);
    }
    RosterShipsPositionAdjusted memory rosterShipsPositionAdjusted = RosterAdjustShipsPositionLogic.verify(playerId, sequenceNumber, positions, shipIds, rosterData);
    rosterShipsPositionAdjusted.playerId = playerId;
    rosterShipsPositionAdjusted.sequenceNumber = sequenceNumber;
    emit RosterShipsPositionAdjustedEvent(rosterShipsPositionAdjusted.playerId, rosterShipsPositionAdjusted.sequenceNumber, rosterShipsPositionAdjusted.positions, rosterShipsPositionAdjusted.shipIds);
    RosterData memory updatedRosterData = RosterAdjustShipsPositionLogic.mutate(rosterShipsPositionAdjusted, rosterData);
    Roster.set(playerId, sequenceNumber, updatedRosterData);
  }

  function rosterTransferShip(uint256 playerId, uint32 sequenceNumber, uint256 shipId, uint256 toRosterPlayerId, uint32 toRosterSequenceNumber, uint64 toPosition) public {
    RosterData memory rosterData = Roster.get(playerId, sequenceNumber);
    if (rosterData.status == uint8(0) && rosterData.speed == uint32(0) && rosterData.baseExperience == uint32(0) && rosterData.environmentOwned == false && rosterData.updatedCoordinatesX == uint32(0) && rosterData.updatedCoordinatesY == uint32(0) && rosterData.coordinatesUpdatedAt == uint64(0) && rosterData.targetCoordinatesX == uint32(0) && rosterData.targetCoordinatesY == uint32(0) && rosterData.originCoordinatesX == uint32(0) && rosterData.originCoordinatesY == uint32(0) && rosterData.sailDuration == uint64(0) && rosterData.setSailAt == uint64(0) && rosterData.currentSailSegment == uint16(0) && rosterData.shipBattleId == uint256(0) && rosterData.shipIds.length == 0) {
      revert RosterDoesNotExist(playerId, sequenceNumber);
    }
    RosterShipTransferred memory rosterShipTransferred = RosterTransferShipLogic.verify(playerId, sequenceNumber, shipId, toRosterPlayerId, toRosterSequenceNumber, toPosition, rosterData);
    rosterShipTransferred.playerId = playerId;
    rosterShipTransferred.sequenceNumber = sequenceNumber;
    emit RosterShipTransferredEvent(rosterShipTransferred.playerId, rosterShipTransferred.sequenceNumber, rosterShipTransferred.shipId, rosterShipTransferred.toRosterPlayerId, rosterShipTransferred.toRosterSequenceNumber, rosterShipTransferred.toPosition, rosterShipTransferred.transferredAt);
    RosterData memory updatedRosterData = RosterTransferShipLogic.mutate(rosterShipTransferred, rosterData);
    Roster.set(playerId, sequenceNumber, updatedRosterData);
  }

  function rosterTransferMultiShips(uint256 playerId, uint32 sequenceNumber, uint256[] memory shipIds, uint256 toRosterPlayerId, uint32 toRosterSequenceNumber, uint64 toPosition) public {
    RosterData memory rosterData = Roster.get(playerId, sequenceNumber);
    if (rosterData.status == uint8(0) && rosterData.speed == uint32(0) && rosterData.baseExperience == uint32(0) && rosterData.environmentOwned == false && rosterData.updatedCoordinatesX == uint32(0) && rosterData.updatedCoordinatesY == uint32(0) && rosterData.coordinatesUpdatedAt == uint64(0) && rosterData.targetCoordinatesX == uint32(0) && rosterData.targetCoordinatesY == uint32(0) && rosterData.originCoordinatesX == uint32(0) && rosterData.originCoordinatesY == uint32(0) && rosterData.sailDuration == uint64(0) && rosterData.setSailAt == uint64(0) && rosterData.currentSailSegment == uint16(0) && rosterData.shipBattleId == uint256(0) && rosterData.shipIds.length == 0) {
      revert RosterDoesNotExist(playerId, sequenceNumber);
    }
    RosterMultiShipsTransferred memory rosterMultiShipsTransferred = RosterTransferMultiShipsLogic.verify(playerId, sequenceNumber, shipIds, toRosterPlayerId, toRosterSequenceNumber, toPosition, rosterData);
    rosterMultiShipsTransferred.playerId = playerId;
    rosterMultiShipsTransferred.sequenceNumber = sequenceNumber;
    emit RosterMultiShipsTransferredEvent(rosterMultiShipsTransferred.playerId, rosterMultiShipsTransferred.sequenceNumber, rosterMultiShipsTransferred.shipIds, rosterMultiShipsTransferred.toRosterPlayerId, rosterMultiShipsTransferred.toRosterSequenceNumber, rosterMultiShipsTransferred.toPosition, rosterMultiShipsTransferred.transferredAt);
    RosterData memory updatedRosterData = RosterTransferMultiShipsLogic.mutate(rosterMultiShipsTransferred, rosterData);
    Roster.set(playerId, sequenceNumber, updatedRosterData);
  }

}
