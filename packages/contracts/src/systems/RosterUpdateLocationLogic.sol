// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { RosterLocationUpdated } from "./RosterEvents.sol";
import { RosterData } from "../codegen/index.sol";
import { SailIntPointData } from "../codegen/index.sol";
import { SailIntPointLib } from "./SailIntPointLib.sol";
import { SailIntPoint } from "../codegen/index.sol";
import { RosterStatus } from "./RosterStatus.sol";
import { RouteUtil } from "../utils/RouteUtil.sol";
import { Coordinates } from "./Coordinates.sol";

// Add these custom errors at the top of the file, after the imports
error RosterNotUnderway(uint8 currentStatus);
error InvalidSailSegment(uint16 currentSailSegment, uint16 oldSailSegment);
error InvalidPositionUpdateAfterSailDuration(Coordinates segmentEnd, Coordinates updatedCoordinates);
error InvalidPositionUpdate(
  Coordinates segmentStart,
  Coordinates segmentEnd,
  uint64 segmentStartTime,
  uint64 segmentEndTime,
  uint64 currentTime,
  Coordinates updatedCoordinates
);

/**
 * @title RosterUpdateLocationLogic Library
 * @dev Implements the Roster.UpdateLocation method.
 */
library RosterUpdateLocationLogic {
  /**
   * @notice Verifies the Roster.UpdateLocation command.
   * @param rosterData The current state the Roster.
   * @return A RosterLocationUpdated event struct.
   */
  function verify(
    uint256 playerId,
    uint32 sequenceNumber,
    uint32 updatedCoordinatesX,
    uint32 updatedCoordinatesY,
    uint16 currentSailSegment,
    RosterData memory rosterData
  ) internal view returns (RosterLocationUpdated memory) {
    if (rosterData.status != RosterStatus.UNDERWAY) {
      revert RosterNotUnderway(rosterData.status);
    }
    uint64 currentTime = uint64(block.timestamp);
    SailIntPointData[] memory sailIntermediatePoints = SailIntPointLib.getAllSailIntermediatePoints(
      playerId,
      sequenceNumber
    );
    uint16 oldSailSegment = rosterData.currentSailSegment;
    if (oldSailSegment > sailIntermediatePoints.length) {
      oldSailSegment = uint16(sailIntermediatePoints.length);
    }
    if (sailIntermediatePoints.length > 0) {
      if (currentSailSegment < oldSailSegment) {
        revert InvalidSailSegment(currentSailSegment, oldSailSegment);
      }
      if (currentSailSegment > sailIntermediatePoints.length) {
        currentSailSegment = uint16(sailIntermediatePoints.length);
      }
    } else {
      currentSailSegment = 0;
    }
    // Get current sail segment start and end coordinates
    Coordinates memory segmentStart = currentSailSegment == 0
      ? Coordinates({ x: rosterData.originCoordinatesX, y: rosterData.originCoordinatesY })
      : Coordinates({
        x: sailIntermediatePoints[currentSailSegment - 1].coordinatesX,
        y: sailIntermediatePoints[currentSailSegment - 1].coordinatesY
      });
    Coordinates memory segmentEnd = currentSailSegment == sailIntermediatePoints.length
      ? Coordinates({ x: rosterData.targetCoordinatesX, y: rosterData.targetCoordinatesY })
      : Coordinates({
        x: sailIntermediatePoints[currentSailSegment].coordinatesX,
        y: sailIntermediatePoints[currentSailSegment].coordinatesY
      });
    uint64 segmentStartTime = currentSailSegment == 0
      ? rosterData.setSailAt
      : sailIntermediatePoints[currentSailSegment - 1].segmentShouldStartAt;
    uint64 segmentEndTime = currentSailSegment == sailIntermediatePoints.length
      ? rosterData.setSailAt + rosterData.sailDuration
      : sailIntermediatePoints[currentSailSegment].segmentShouldStartAt;

    if (currentTime >= segmentEndTime && currentSailSegment == sailIntermediatePoints.length) {
      bool isValid = RouteUtil.isValidPositionUpdateAfterSailDuration(
        segmentEnd,
        Coordinates({ x: updatedCoordinatesX, y: updatedCoordinatesY })
      );
      if (!isValid) {
        revert InvalidPositionUpdateAfterSailDuration(
          segmentEnd,
          Coordinates({ x: updatedCoordinatesX, y: updatedCoordinatesY })
        );
      }
    } else {
      bool isValid = RouteUtil.isValidPositionUpdate(
        segmentStart,
        segmentEnd,
        segmentStartTime,
        segmentEndTime,
        currentTime,
        Coordinates({ x: updatedCoordinatesX, y: updatedCoordinatesY })
      );
      if (!isValid) {
        revert InvalidPositionUpdate(
          segmentStart,
          segmentEnd,
          segmentStartTime,
          segmentEndTime,
          currentTime,
          Coordinates({ x: updatedCoordinatesX, y: updatedCoordinatesY })
        );
      }
    }
    uint8 newStatus = rosterData.status;
    if (updatedCoordinatesX == rosterData.targetCoordinatesX && updatedCoordinatesY == rosterData.targetCoordinatesY) {
      newStatus = RosterStatus.AT_ANCHOR;
    }
    RosterLocationUpdated memory e;
    e.playerId = playerId;
    e.sequenceNumber = sequenceNumber;
    e.currentSailSegment = currentSailSegment;
    e.updatedCoordinatesX = updatedCoordinatesX;
    e.updatedCoordinatesY = updatedCoordinatesY;
    e.coordinatesUpdatedAt = currentTime;
    e.newStatus = newStatus;
    e.oldStatus = rosterData.status;
    return e;
  }

  /**
   * @notice Performs the state mutation operation of Roster.UpdateLocation method.
   * @dev This function is called after verification to update the Roster's state.
   * @param rosterLocationUpdated The RosterLocationUpdated event struct from the verify function.
   * @param rosterData The current state of the Roster.
   * @return The new state of the Roster.
   */
  function mutate(
    RosterLocationUpdated memory rosterLocationUpdated,
    RosterData memory rosterData
  ) internal pure returns (RosterData memory) {
    // Update the roster's status
    rosterData.status = uint8(rosterLocationUpdated.newStatus);

    // Update the coordinates
    rosterData.updatedCoordinatesX = rosterLocationUpdated.updatedCoordinatesX;
    rosterData.updatedCoordinatesY = rosterLocationUpdated.updatedCoordinatesY;

    // Update the timestamp of the last coordinate update
    rosterData.coordinatesUpdatedAt = rosterLocationUpdated.coordinatesUpdatedAt;

    // Update the current sail segment
    rosterData.currentSailSegment = rosterLocationUpdated.currentSailSegment;

    return rosterData;
  }
}
