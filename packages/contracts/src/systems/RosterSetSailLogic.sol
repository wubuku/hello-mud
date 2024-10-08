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
import { UpdateLocationParams } from "./UpdateLocationParams.sol";

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
    UpdateLocationParams memory updateLocationParams,
    Coordinates[] memory intermediatePoints,
    RosterData memory rosterData
  ) internal returns (RosterSetSail memory) {
    PlayerUtil.assertSenderIsPlayerOwner(playerId);
    RosterUtil.assertRosterIsNotUnassignedShips(sequenceNumber);
    //
    // NOTE: Before this function is called,
    // the external function needs to check arguments `updatedCoordinatesX`, `updatedCoordinatesY`
    // and update the current position of the Roster if necessary,
    // and reset rosterData.status to RosterStatus.AT_ANCHOR or RosterStatus.UNDERWAY.
    //
    uint32 updatedCoordinatesX = updateLocationParams.updatedCoordinates.x;
    if (updatedCoordinatesX == 0) {
      updatedCoordinatesX = rosterData.updatedCoordinatesX;
    }
    uint32 updatedCoordinatesY = updateLocationParams.updatedCoordinates.y;
    if (updatedCoordinatesY == 0) {
      updatedCoordinatesY = rosterData.updatedCoordinatesY;
    }
    uint16 updatedSailSegment = updateLocationParams.updatedSailSegment;

    if (rosterData.status != RosterStatus.AT_ANCHOR && rosterData.status != RosterStatus.UNDERWAY) {
      revert RosterUnfitToSail(rosterData.status);
    }
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
    e.updateLocationParams = UpdateLocationParams({
      updatedCoordinates: Coordinates(updatedCoordinatesX, updatedCoordinatesY),
      updatedSailSegment: 0, //updatedSailSegment
      updatedAt: setSailAt
    });
    e.intermediatePoints = intermediatePoints;
    return e;
  }

  function mutate(
    RosterSetSail memory rosterSetSail,
    RosterData memory rosterData
  ) internal pure returns (RosterData memory) {
    rosterData.updatedCoordinatesX = rosterSetSail.updateLocationParams.updatedCoordinates.x;
    rosterData.updatedCoordinatesY = rosterSetSail.updateLocationParams.updatedCoordinates.y;
    rosterData.targetCoordinatesX = rosterSetSail.targetCoordinatesX;
    rosterData.targetCoordinatesY = rosterSetSail.targetCoordinatesY;
    rosterData.originCoordinatesX = rosterSetSail.updateLocationParams.updatedCoordinates.x;
    rosterData.originCoordinatesY = rosterSetSail.updateLocationParams.updatedCoordinates.y;
    rosterData.coordinatesUpdatedAt = rosterSetSail.setSailAt;
    rosterData.setSailAt = rosterSetSail.setSailAt;
    rosterData.currentSailSegment = 0; // reset current sail segment
    if (
      rosterSetSail.targetCoordinatesX != rosterSetSail.updateLocationParams.updatedCoordinates.x ||
      rosterSetSail.targetCoordinatesY != rosterSetSail.updateLocationParams.updatedCoordinates.y
    ) {
      rosterData.status = uint8(RosterStatus.UNDERWAY);
    } else {
      rosterData.status = uint8(RosterStatus.AT_ANCHOR);
    }

    rosterData.sailDuration = rosterSetSail.sailDuration;

    return rosterData;
  }
}
