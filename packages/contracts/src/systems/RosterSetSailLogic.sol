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
    (uint64 totalDuration, uint64[] memory segmentDurations) = SpeedUtil.calculateSailDurationAndSegments(
      rosterData.speed,
      Coordinates(updatedCoordinatesX, updatedCoordinatesY),
      Coordinates(targetCoordinatesX, targetCoordinatesY),
      intermediatePoints
    );

    if (sailDuration < totalDuration) {
      revert IllegalSailDuration(totalDuration, sailDuration);
    }

    uint64 setSailAt = uint64(block.timestamp);
    // Create sailIntPoints using the returned segmentDurations
    SailIntPointData[] memory sailIntPoints = new SailIntPointData[](intermediatePoints.length);
    uint64 cumulativeDuration = 0;
    for (uint256 i = 0; i < intermediatePoints.length; i++) {
      cumulativeDuration += segmentDurations[i];
      sailIntPoints[i] = SailIntPointData(
        intermediatePoints[i].x,
        intermediatePoints[i].y,
        setSailAt + cumulativeDuration // The segment after this point will start at this timestamp
      );
    }

    SailIntPointLib.updateAllSailIntermediatePoints(playerId, sequenceNumber, sailIntPoints);

    // Construct the return value step by step
    RosterSetSail memory e;
    e.playerId = playerId;
    e.sequenceNumber = sequenceNumber;
    e.targetCoordinatesX = targetCoordinatesX;
    e.targetCoordinatesY = targetCoordinatesY;
    e.sailDuration = sailDuration;
    e.setSailAt = setSailAt;
    e.updatedCoordinatesX = updatedCoordinatesX;
    e.updatedCoordinatesY = updatedCoordinatesY;
    e.updatedSailSegment = updatedSailSegment;
    e.intermediatePoints = intermediatePoints;
    return e;
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
