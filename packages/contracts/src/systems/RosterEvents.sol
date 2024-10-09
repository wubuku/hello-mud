// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { UpdateLocationParams } from "./UpdateLocationParams.sol";

import { Coordinates } from "./Coordinates.sol";

import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";

struct RosterCreated {
  /**
   * @dev The PlayerId of the RosterId.
   */
  uint256 playerId;
  /**
   * @dev The SequenceNumber of the RosterId.
   */
  uint32 sequenceNumber;
  /**
   * @dev The X of the Coordinates.
   */
  uint32 coordinatesX;
  /**
   * @dev The Y of the Coordinates.
   */
  uint32 coordinatesY;
}

struct EnvironmentRosterCreated {
  /**
   * @dev The PlayerId of the RosterId.
   */
  uint256 playerId;
  /**
   * @dev The SequenceNumber of the RosterId.
   */
  uint32 sequenceNumber;
  /**
   * @dev The X of the Coordinates.
   */
  uint32 coordinatesX;
  /**
   * @dev The Y of the Coordinates.
   */
  uint32 coordinatesY;
  uint32 shipResourceQuantity;
  uint32 shipBaseResourceQuantity;
  uint32 baseExperience;
}

struct RosterShipAdded {
  /**
   * @dev The PlayerId of the RosterId.
   */
  uint256 playerId;
  /**
   * @dev The SequenceNumber of the RosterId.
   */
  uint32 sequenceNumber;
  uint256 shipId;
  uint64 position;
}

struct RosterSetSail {
  /**
   * @dev The PlayerId of the RosterId.
   */
  uint256 playerId;
  /**
   * @dev The SequenceNumber of the RosterId.
   */
  uint32 sequenceNumber;
  /**
   * @dev The X of the TargetCoordinates.
   */
  uint32 targetCoordinatesX;
  /**
   * @dev The Y of the TargetCoordinates.
   */
  uint32 targetCoordinatesY;
  uint64 sailDuration;
  UpdateLocationParams updateLocationParams;
  Coordinates[] intermediatePoints;
  uint64 setSailAt;
}

struct RosterLocationUpdated {
  /**
   * @dev The PlayerId of the RosterId.
   */
  uint256 playerId;
  /**
   * @dev The SequenceNumber of the RosterId.
   */
  uint32 sequenceNumber;
  UpdateLocationParams updateLocationParams;
  uint64 coordinatesUpdatedAt;
  uint8 newStatus;
  uint8 oldStatus;
}

struct RosterBattleDestroyedShipsCleanedUp {
  /**
   * @dev The PlayerId of the RosterId.
   */
  uint256 playerId;
  /**
   * @dev The SequenceNumber of the RosterId.
   */
  uint32 sequenceNumber;
  /**
   * @dev The PlayerId of the LoserRosterId.
   */
  uint256 loserRosterIdPlayerId;
  /**
   * @dev The SequenceNumber of the LoserRosterId.
   */
  uint32 loserRosterIdSequenceNumber;
  uint8 choice;
}

struct RosterShipsPositionAdjusted {
  /**
   * @dev The PlayerId of the RosterId.
   */
  uint256 playerId;
  /**
   * @dev The SequenceNumber of the RosterId.
   */
  uint32 sequenceNumber;
  uint64[] positions;
  uint256[] shipIds;
}

struct RosterShipTransferred {
  /**
   * @dev The PlayerId of the RosterId.
   */
  uint256 playerId;
  /**
   * @dev The SequenceNumber of the RosterId.
   */
  uint32 sequenceNumber;
  uint256 shipId;
  /**
   * @dev The PlayerId of the ToRoster.
   */
  uint256 toRosterPlayerId;
  /**
   * @dev The SequenceNumber of the ToRoster.
   */
  uint32 toRosterSequenceNumber;
  uint64 toPosition;
  uint64 transferredAt;
}

struct RosterShipInventoryTransferred {
  /**
   * @dev The PlayerId of the RosterId.
   */
  uint256 playerId;
  /**
   * @dev The SequenceNumber of the RosterId.
   */
  uint32 sequenceNumber;
  uint256 fromShipId;
  uint256 toShipId;
  ItemIdQuantityPair[] itemIdQuantityPairs;
}

struct RosterShipInventoryTakenOut {
  /**
   * @dev The PlayerId of the RosterId.
   */
  uint256 playerId;
  /**
   * @dev The SequenceNumber of the RosterId.
   */
  uint32 sequenceNumber;
  uint256 shipId;
  ItemIdQuantityPair[] itemIdQuantityPairs;
  UpdateLocationParams updateLocationParams;
}

struct RosterShipInventoryPutIn {
  /**
   * @dev The PlayerId of the RosterId.
   */
  uint256 playerId;
  /**
   * @dev The SequenceNumber of the RosterId.
   */
  uint32 sequenceNumber;
  uint256 shipId;
  ItemIdQuantityPair[] itemIdQuantityPairs;
  UpdateLocationParams updateLocationParams;
}

