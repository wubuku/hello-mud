// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { RosterData, ShipData, Ship } from "../codegen/index.sol";
import { DirectRouteUtil } from "./DirectRouteUtil.sol";
import { SpeedUtil } from "./SpeedUtil.sol";
import { RosterStatus } from "../systems/RosterStatus.sol";

library RosterDataInstance {
  uint256 private constant MIN_DISTANCE_TO_TRANSFER = 3000;

  error EmptyRosterShipIds();
  error InvalidRosterStatus();
  error TargetCoordinatesNotSet();
  error InvalidRosterUpdateTime();
  error OriginCoordinatesNotSet();
  error PlayerHasNoClaimedIsland();
  error InconsistentRosterShipId();
  error RosterIsFull();
  error IsEnvironmentRoster();
  error RosterIslandNotCloseEnough();
  error ShipDoesNotExist();

  function areRostersCloseEnoughToTransfer(
    RosterData memory roster1,
    RosterData memory roster2
  ) internal pure returns (bool) {
    return
      DirectRouteUtil.getDistance(
        roster1.updatedCoordinatesX,
        roster1.updatedCoordinatesY,
        roster2.updatedCoordinatesX,
        roster2.updatedCoordinatesY
      ) <= MIN_DISTANCE_TO_TRANSFER;
  }

  function isDestroyedExceptShip(RosterData memory roster, uint256 shipId) internal view returns (bool) {
    uint256[] memory shipIds = roster.shipIds;
    for (uint256 i = 0; i < shipIds.length; i++) {
      if (shipIds[i] == shipId) {
        continue;
      }
      ShipData memory ship = getShipAndValidate(shipIds[i]);
      if (ship.healthPoints > 0) {
        return false;
      }
    }
    return true;
  }

  function assertRosterShipsNotFull(RosterData memory roster) internal pure {
    if (roster.shipIds.length >= 4) {
      revert RosterIsFull();
    }
  }

  function assertRosterShipsNotEmpty(RosterData memory roster) internal pure {
    if (roster.shipIds.length == 0) {
      revert EmptyRosterShipIds();
    }
  }

  function assertRosterIslandCloseEnoughToTransfer(
    RosterData memory roster,
    uint32 playerClaimedIslandX,
    uint32 playerClaimedIslandY
  ) internal pure {
    if (roster.environmentOwned) {
      revert IsEnvironmentRoster();
    }
    if (playerClaimedIslandX == uint32(0) && playerClaimedIslandY == uint32(0)) {
      revert PlayerHasNoClaimedIsland();
    }
    uint256 distance = DirectRouteUtil.getDistance(
      roster.updatedCoordinatesX,
      roster.updatedCoordinatesY,
      playerClaimedIslandX,
      playerClaimedIslandY
    );
    if (distance >= MIN_DISTANCE_TO_TRANSFER) {
      revert RosterIslandNotCloseEnough();
    }
  }

  function calculateRosterSpeed(RosterData memory roster) internal view returns (uint32) {
    uint256[] memory shipIds = roster.shipIds;
    if (shipIds.length == 0) {
      return 0;
    }
    uint32 totalSpeed = 0;
    for (uint256 i = 0; i < shipIds.length; i++) {
      ShipData memory ship = getShipAndValidate(shipIds[i]);
      totalSpeed += ship.speed;
    }
    return totalSpeed / uint32(shipIds.length);
  }

  function isDestroyed(RosterData memory roster) internal view returns (bool) {
    uint256[] memory shipIds = roster.shipIds;
    for (uint256 i = 0; i < shipIds.length; i++) {
      ShipData memory ship = getShipAndValidate(shipIds[i]);
      if (ship.healthPoints > 0) {
        return false;
      }
    }
    return true;
  }

  function getLastShipId(RosterData memory roster) internal pure returns (uint256) {
    if (roster.shipIds.length == 0) {
      revert EmptyRosterShipIds();
    }
    return roster.shipIds[roster.shipIds.length - 1];
  }

  function isStatusBattleReady(RosterData memory roster) internal pure returns (bool) {
    return roster.status == RosterStatus.AT_ANCHOR || roster.status == RosterStatus.UNDERWAY;
  }

  function isCurrentLocationUpdatable(
    RosterData memory roster,
    uint256 currentTimestamp,
    uint256 updatedCoordinatesX,
    uint256 updatedCoordinatesY
  ) internal pure returns (bool, uint256, uint8) {
    uint8 oldStatus = roster.status;
    uint256 coordinatesUpdatedAt = roster.coordinatesUpdatedAt;

    if (updatedCoordinatesX == 0 || updatedCoordinatesY == 0) {
      return (false, coordinatesUpdatedAt, oldStatus);
    }

    if (oldStatus != 2) {
      revert InvalidRosterStatus();
    }
    if (roster.targetCoordinatesX == 0 && roster.targetCoordinatesY == 0) {
      revert TargetCoordinatesNotSet();
    }
    if (roster.originCoordinatesX == 0 && roster.originCoordinatesY == 0) {
      revert OriginCoordinatesNotSet();
    }

    uint8 newStatus = oldStatus;
    (uint256 speedNumerator, uint256 speedDenominator) = SpeedUtil.speedPropertyToCoordinateUnitsPerSecond(
      roster.speed
    );
    if (currentTimestamp < coordinatesUpdatedAt) {
      revert InvalidRosterUpdateTime();
    }
    uint256 elapsedTime = currentTimestamp - coordinatesUpdatedAt;

    // TODO: Implement the rest of the function
    bool updatable = true;
    // Use speedNumerator, speedDenominator, elapsedTime, and origin coordinates as needed

    if (roster.targetCoordinatesX == updatedCoordinatesX && roster.targetCoordinatesY == updatedCoordinatesY) {
      newStatus = RosterStatus.AT_ANCHOR;
    }
    coordinatesUpdatedAt = currentTimestamp;
    return (updatable, coordinatesUpdatedAt, newStatus);
  }

  function getShipAndValidate(uint256 shipId) private view returns (ShipData memory) {
    ShipData memory ship = Ship.get(shipId);
    if (
      ship.speed == 0 &&
      ship.protection == 0 &&
      ship.attack == 0 &&
      ship.playerId == 0 &&
      ship.rosterSequenceNumber == 0
    ) {
      revert ShipDoesNotExist();
    }
    return ship;
  }
}