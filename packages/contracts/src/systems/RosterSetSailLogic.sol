// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { RosterSetSail } from "./RosterEvents.sol";
import { RosterData, PlayerData } from "../codegen/index.sol";
import { PlayerUtil } from "../utils/PlayerUtil.sol";
import { RosterUtil } from "../utils/RosterUtil.sol";
import { RosterDataInstance } from "../utils/RosterDataInstance.sol";
import { SpeedUtil } from "../utils/SpeedUtil.sol";
import { RosterStatus } from "./RosterStatus.sol";
import { Coordinates } from "./Coordinates.sol";

library RosterSetSailLogic {
  using RosterDataInstance for RosterData;

  error RosterUnfitToSail(uint8 status);
  error NotEnoughEnergy(uint256 required, uint256 provided);
  error IllegalSailDuration(uint64 required, uint64 provided);
  error InvalidUpdatedCoordinates(uint32 x, uint32 y);

  uint256 private constant ENERGY_AMOUNT_PER_SECOND_PER_SHIP = 1388889;

  function verify(
    uint256 playerId,
    uint32 sequenceNumber,
    uint32 targetCoordinatesX,
    uint32 targetCoordinatesY,
    uint64 sailDuration,
    uint32 updatedCoordinatesX,
    uint32 updatedCoordinatesY,
    RosterData memory rosterData
  ) internal view returns (RosterSetSail memory) {
    PlayerData memory playerData = PlayerUtil.assertSenderIsPlayerOwner(playerId);
    RosterUtil.assertRosterIsNotUnassignedShips(sequenceNumber);
    rosterData.assertRosterShipsNotEmpty();

    uint32 newUpdatedCoordinatesX;
    uint32 newUpdatedCoordinatesY;
    uint8 status = rosterData.status;

    if (status == uint8(RosterStatus.AT_ANCHOR)) {
      newUpdatedCoordinatesX = rosterData.updatedCoordinatesX;
      newUpdatedCoordinatesY = rosterData.updatedCoordinatesY;
    } else if (status == uint8(RosterStatus.UNDERWAY)) {
      (bool updatable, uint64 _coordinatesUpdatedAt, uint8 _newStatus) = rosterData.isCurrentLocationUpdatable(
        uint64(block.timestamp),
        updatedCoordinatesX,
        updatedCoordinatesY
      );
      if (updatable) {
        newUpdatedCoordinatesX = updatedCoordinatesX;
        newUpdatedCoordinatesY = updatedCoordinatesY;
      } else {
        revert InvalidUpdatedCoordinates(updatedCoordinatesX, updatedCoordinatesY);
      }
    } else {
      revert RosterUnfitToSail(status);
    }

    uint64 totalTime = SpeedUtil.calculateTotalTime(
      Coordinates(newUpdatedCoordinatesX, newUpdatedCoordinatesY),
      Coordinates(targetCoordinatesX, targetCoordinatesY),
      rosterData.speed
    );

    if (sailDuration < totalTime) {
      revert IllegalSailDuration(totalTime, sailDuration);
    }

    uint256 shipCount = rosterData.shipIds.length;
    uint64 requiredEnergy = 0; // TODO totalTime * shipCount * ENERGY_AMOUNT_PER_SECOND_PER_SHIP;

    uint64 setSailAt = uint64(block.timestamp);

    return
      RosterSetSail({
        playerId: playerId,
        sequenceNumber: sequenceNumber,
        targetCoordinatesX: targetCoordinatesX,
        targetCoordinatesY: targetCoordinatesY,
        sailDuration: sailDuration,
        setSailAt: setSailAt,
        updatedCoordinatesX: newUpdatedCoordinatesX,
        updatedCoordinatesY: newUpdatedCoordinatesY,
        energyCost: requiredEnergy
      });
  }

  function mutate(
    RosterSetSail memory rosterSetSail,
    RosterData memory rosterData
  ) internal pure returns (RosterData memory) {
    rosterData.updatedCoordinatesX = rosterSetSail.updatedCoordinatesX;
    rosterData.updatedCoordinatesY = rosterSetSail.updatedCoordinatesY;
    rosterData.targetCoordinatesX = rosterSetSail.targetCoordinatesX;
    rosterData.targetCoordinatesY = rosterSetSail.targetCoordinatesY;
    rosterData.originCoordinatesX = rosterSetSail.updatedCoordinatesX;
    rosterData.originCoordinatesY = rosterSetSail.updatedCoordinatesY;
    rosterData.coordinatesUpdatedAt = rosterSetSail.setSailAt;
    rosterData.setSailAt = rosterSetSail.setSailAt;

    if (
      rosterSetSail.targetCoordinatesX != rosterSetSail.updatedCoordinatesX ||
      rosterSetSail.targetCoordinatesY != rosterSetSail.updatedCoordinatesY
    ) {
      rosterData.status = uint8(RosterStatus.UNDERWAY);
    } else {
      rosterData.status = uint8(RosterStatus.AT_ANCHOR);
    }

    rosterData.sailDuration = rosterSetSail.sailDuration;

    return rosterData;
  }
}
