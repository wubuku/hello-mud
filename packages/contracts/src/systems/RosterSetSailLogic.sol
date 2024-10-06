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


  function verify(
    uint256 playerId,
    uint32 sequenceNumber,
    uint32 targetCoordinatesX,
    uint32 targetCoordinatesY,
    uint64 sailDuration,
    uint32 updatedCoordinatesX,
    uint32 updatedCoordinatesY,
    uint16 updatedSailSegment,
    Coordinates[] memory intermediatePoints,
    RosterData memory rosterData
  ) internal view returns (RosterSetSail memory) {
    PlayerData memory playerData = PlayerUtil.assertSenderIsPlayerOwner(playerId);

    // uint64 totalTime = SpeedUtil.calculateTotalTime(
    //   Coordinates(newUpdatedCoordinatesX, newUpdatedCoordinatesY),
    //   Coordinates(targetCoordinatesX, targetCoordinatesY),
    //   rosterData.speed
    // );

    // if (sailDuration < totalTime) {
    //   revert IllegalSailDuration(totalTime, sailDuration);
    // }

    //uint256 shipCount = rosterData.shipIds.length;
    //uint64 requiredEnergy = totalTime * shipCount * ENERGY_AMOUNT_PER_SECOND_PER_SHIP;

    uint64 setSailAt = uint64(block.timestamp);

    return
      RosterSetSail({
        playerId: playerId,
        sequenceNumber: sequenceNumber,
        targetCoordinatesX: targetCoordinatesX,
        targetCoordinatesY: targetCoordinatesY,
        sailDuration: sailDuration,
        setSailAt: setSailAt,
        updatedCoordinatesX: updatedCoordinatesX,
        updatedCoordinatesY: updatedCoordinatesY,
        updatedSailSegment: updatedSailSegment,
        intermediatePoints: intermediatePoints
        // energyCost: requiredEnergy
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
    //todo intermediate points
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
