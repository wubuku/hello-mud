// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { RosterSetSail } from "./RosterEvents.sol";
import { RosterData, PlayerData, SailIntPointData } from "../codegen/index.sol";
import { PlayerUtil } from "../utils/PlayerUtil.sol";
import { RosterUtil } from "../utils/RosterUtil.sol";
import { RosterDataInstance } from "../utils/RosterDataInstance.sol";
import { SpeedUtil } from "../utils/SpeedUtil.sol";
import { RosterStatus } from "./RosterStatus.sol";
import { Coordinates } from "./Coordinates.sol";
import { SailIntPointLib } from "./SailIntPointLib.sol";

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
  ) internal returns (RosterSetSail memory) {
    PlayerData memory playerData = PlayerUtil.assertSenderIsPlayerOwner(playerId);

    uint64 totalDuration = 0;

    uint64 setSailAt = uint64(block.timestamp);

    SailIntPointData[] memory sailIntPoints = new SailIntPointData[](intermediatePoints.length);
    uint32 lastX = updatedCoordinatesX;
    uint32 lastY = updatedCoordinatesY;
    for (uint256 i = 0; i < intermediatePoints.length; i++) {
      totalDuration += SpeedUtil.calculateTotalTime(
        Coordinates(lastX, lastY),
        intermediatePoints[i],
        rosterData.speed
      );
      sailIntPoints[i] = SailIntPointData(intermediatePoints[i].x, intermediatePoints[i].y, totalDuration);
      lastX = intermediatePoints[i].x;
      lastY = intermediatePoints[i].y;
    }
    totalDuration += SpeedUtil.calculateTotalTime(
      Coordinates(lastX, lastY),
      Coordinates(targetCoordinatesX, targetCoordinatesY),
      rosterData.speed
    );

    if (sailDuration < totalDuration) {
      revert IllegalSailDuration(totalDuration, sailDuration);
    }

    SailIntPointLib.updateAllSailIntermediatePoints(playerId, sequenceNumber, sailIntPoints);

    // NOTE: Energy checks should be performed in the external function that calls this one.
    // We do not perform the check here.
    //uint256 shipCount = rosterData.shipIds.length;
    //uint64 requiredEnergy = totalDuration * shipCount * ENERGY_AMOUNT_PER_SECOND_PER_SHIP;

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
