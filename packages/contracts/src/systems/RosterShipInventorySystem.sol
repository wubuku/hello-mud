// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { System } from "@latticexyz/world/src/System.sol";
import { Roster, RosterData } from "../codegen/index.sol";
import { RosterShipInventoryTransferred, RosterShipInventoryTakenOut, RosterShipInventoryPutIn } from "./RosterEvents.sol";
import { RosterTransferShipInventoryLogic } from "./RosterTransferShipInventoryLogic.sol";
import { RosterTakeOutShipInventoryLogic } from "./RosterTakeOutShipInventoryLogic.sol";
import { RosterPutInShipInventoryLogic } from "./RosterPutInShipInventoryLogic.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";
import { SystemRegistry } from "@latticexyz/world/src/codegen/tables/SystemRegistry.sol";
import { NamespaceOwner } from "@latticexyz/world/src/codegen/tables/NamespaceOwner.sol";
import { ResourceId, WorldResourceIdInstance } from "@latticexyz/world/src/WorldResourceId.sol";

contract RosterShipInventorySystem is System {
  using WorldResourceIdInstance for ResourceId;

  event RosterShipInventoryTransferredEvent(uint256 indexed playerId, uint32 indexed sequenceNumber, uint256 fromShipId, uint256 toShipId);

  event RosterShipInventoryTakenOutEvent(uint256 indexed playerId, uint32 indexed sequenceNumber, uint256 shipId, uint32 updatedCoordinatesX, uint32 updatedCoordinatesY, uint16 updatedSailSegment);

  event RosterShipInventoryPutInEvent(uint256 indexed playerId, uint32 indexed sequenceNumber, uint256 shipId, uint32 updatedCoordinatesX, uint32 updatedCoordinatesY, uint16 updatedSailSegment);

  function _requireNamespaceOwner() internal view {
    ResourceId _thisSystemId = SystemRegistry.get(address(this));
    address _thisNamespaceOwner = NamespaceOwner.get(_thisSystemId.getNamespaceId());
    require(_thisNamespaceOwner == _msgSender(), "Require namespace owner");
  }

  function rosterTransferShipInventory(uint256 playerId, uint32 sequenceNumber, uint256 fromShipId, uint256 toShipId, ItemIdQuantityPair[] memory itemIdQuantityPairs) public {
    RosterData memory rosterData = Roster.get(playerId, sequenceNumber);
    require(
      !(rosterData.status == uint8(0) && rosterData.speed == uint32(0) && rosterData.baseExperience == uint32(0) && rosterData.environmentOwned == false && rosterData.updatedCoordinatesX == uint32(0) && rosterData.updatedCoordinatesY == uint32(0) && rosterData.coordinatesUpdatedAt == uint64(0) && rosterData.targetCoordinatesX == uint32(0) && rosterData.targetCoordinatesY == uint32(0) && rosterData.originCoordinatesX == uint32(0) && rosterData.originCoordinatesY == uint32(0) && rosterData.sailDuration == uint64(0) && rosterData.setSailAt == uint64(0) && rosterData.currentSailSegment == uint16(0) && rosterData.shipBattleId == uint256(0) && rosterData.shipIds.length == 0),
      "Roster does not exist"
    );
    RosterShipInventoryTransferred memory rosterShipInventoryTransferred = RosterTransferShipInventoryLogic.verify(playerId, sequenceNumber, fromShipId, toShipId, itemIdQuantityPairs, rosterData);
    rosterShipInventoryTransferred.playerId = playerId;
    rosterShipInventoryTransferred.sequenceNumber = sequenceNumber;
    emit RosterShipInventoryTransferredEvent(rosterShipInventoryTransferred.playerId, rosterShipInventoryTransferred.sequenceNumber, rosterShipInventoryTransferred.fromShipId, rosterShipInventoryTransferred.toShipId);
    RosterData memory updatedRosterData = RosterTransferShipInventoryLogic.mutate(rosterShipInventoryTransferred, rosterData);
    Roster.set(playerId, sequenceNumber, updatedRosterData);
  }

  function rosterTakeOutShipInventory(uint256 playerId, uint32 sequenceNumber, uint256 shipId, ItemIdQuantityPair[] memory itemIdQuantityPairs, uint32 updatedCoordinatesX, uint32 updatedCoordinatesY, uint16 updatedSailSegment) public {
    RosterData memory rosterData = Roster.get(playerId, sequenceNumber);
    require(
      !(rosterData.status == uint8(0) && rosterData.speed == uint32(0) && rosterData.baseExperience == uint32(0) && rosterData.environmentOwned == false && rosterData.updatedCoordinatesX == uint32(0) && rosterData.updatedCoordinatesY == uint32(0) && rosterData.coordinatesUpdatedAt == uint64(0) && rosterData.targetCoordinatesX == uint32(0) && rosterData.targetCoordinatesY == uint32(0) && rosterData.originCoordinatesX == uint32(0) && rosterData.originCoordinatesY == uint32(0) && rosterData.sailDuration == uint64(0) && rosterData.setSailAt == uint64(0) && rosterData.currentSailSegment == uint16(0) && rosterData.shipBattleId == uint256(0) && rosterData.shipIds.length == 0),
      "Roster does not exist"
    );
    RosterShipInventoryTakenOut memory rosterShipInventoryTakenOut = RosterTakeOutShipInventoryLogic.verify(playerId, sequenceNumber, shipId, itemIdQuantityPairs, updatedCoordinatesX, updatedCoordinatesY, updatedSailSegment, rosterData);
    rosterShipInventoryTakenOut.playerId = playerId;
    rosterShipInventoryTakenOut.sequenceNumber = sequenceNumber;
    emit RosterShipInventoryTakenOutEvent(rosterShipInventoryTakenOut.playerId, rosterShipInventoryTakenOut.sequenceNumber, rosterShipInventoryTakenOut.shipId, rosterShipInventoryTakenOut.updatedCoordinatesX, rosterShipInventoryTakenOut.updatedCoordinatesY, rosterShipInventoryTakenOut.updatedSailSegment);
    RosterData memory updatedRosterData = RosterTakeOutShipInventoryLogic.mutate(rosterShipInventoryTakenOut, rosterData);
    Roster.set(playerId, sequenceNumber, updatedRosterData);
  }

  function rosterPutInShipInventory(uint256 playerId, uint32 sequenceNumber, uint256 shipId, ItemIdQuantityPair[] memory itemIdQuantityPairs, uint32 updatedCoordinatesX, uint32 updatedCoordinatesY, uint16 updatedSailSegment) public {
    RosterData memory rosterData = Roster.get(playerId, sequenceNumber);
    require(
      !(rosterData.status == uint8(0) && rosterData.speed == uint32(0) && rosterData.baseExperience == uint32(0) && rosterData.environmentOwned == false && rosterData.updatedCoordinatesX == uint32(0) && rosterData.updatedCoordinatesY == uint32(0) && rosterData.coordinatesUpdatedAt == uint64(0) && rosterData.targetCoordinatesX == uint32(0) && rosterData.targetCoordinatesY == uint32(0) && rosterData.originCoordinatesX == uint32(0) && rosterData.originCoordinatesY == uint32(0) && rosterData.sailDuration == uint64(0) && rosterData.setSailAt == uint64(0) && rosterData.currentSailSegment == uint16(0) && rosterData.shipBattleId == uint256(0) && rosterData.shipIds.length == 0),
      "Roster does not exist"
    );
    RosterShipInventoryPutIn memory rosterShipInventoryPutIn = RosterPutInShipInventoryLogic.verify(playerId, sequenceNumber, shipId, itemIdQuantityPairs, updatedCoordinatesX, updatedCoordinatesY, updatedSailSegment, rosterData);
    rosterShipInventoryPutIn.playerId = playerId;
    rosterShipInventoryPutIn.sequenceNumber = sequenceNumber;
    emit RosterShipInventoryPutInEvent(rosterShipInventoryPutIn.playerId, rosterShipInventoryPutIn.sequenceNumber, rosterShipInventoryPutIn.shipId, rosterShipInventoryPutIn.updatedCoordinatesX, rosterShipInventoryPutIn.updatedCoordinatesY, rosterShipInventoryPutIn.updatedSailSegment);
    RosterData memory updatedRosterData = RosterPutInShipInventoryLogic.mutate(rosterShipInventoryPutIn, rosterData);
    Roster.set(playerId, sequenceNumber, updatedRosterData);
  }

}
