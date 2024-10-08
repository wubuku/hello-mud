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
import { UpdateLocationParams } from "./UpdateLocationParams.sol";

// Add these custom errors at the top of the file, after the imports
error RosterNotUnderway(uint8 currentStatus);
error InvalidSailSegment(uint16 currentSailSegment, uint16 oldSailSegment);
error InvalidPositionUpdateAfterSailDuration(Coordinates segmentEnd, Coordinates updatedCoordinates);
error InvalidPositionUpdate(
  Coordinates segmentStartPoint,
  Coordinates segmentEndPoint,
  uint64 segmentStartTime,
  uint64 segmentEndTime,
  uint64 updateTime,
  Coordinates updatedCoordinates
);
error EarlyUpdate(uint64 updateTime, uint64 currentTime);
error InvalidUpdateTime(uint64 updateTime, uint64 lastUpdateTime);

/**
 * @title RosterUpdateLocationLogic Library
 * @dev Implements the Roster.UpdateLocation method.
 */
library RosterUpdateLocationLogic {
  uint64 constant MAX_UPDATE_TIME_DELAY = 30; // Is this a good value?

  /**
   * @notice Verifies the Roster.UpdateLocation command.
   * @param rosterData The current state the Roster.
   * @return A RosterLocationUpdated event struct.
   */
  function verify(
    uint256 playerId,
    uint32 sequenceNumber,
    UpdateLocationParams memory updateLocationParams,
    RosterData memory rosterData
  ) internal view returns (RosterLocationUpdated memory) {
    uint32 updatedCoordinatesX = updateLocationParams.updatedCoordinates.x;
    uint32 updatedCoordinatesY = updateLocationParams.updatedCoordinates.y;
    uint16 currentSailSegment = updateLocationParams.updatedSailSegment;
    if (updateLocationParams.updatedAt > block.timestamp) {
      revert EarlyUpdate(updateLocationParams.updatedAt, uint64(block.timestamp));
    }
    if (updateLocationParams.updatedAt < rosterData.coordinatesUpdatedAt) {
      revert InvalidUpdateTime(updateLocationParams.updatedAt, rosterData.coordinatesUpdatedAt);
    }

    if (rosterData.status != RosterStatus.UNDERWAY) {
      revert RosterNotUnderway(rosterData.status);
    }
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
    Coordinates memory segmentStartPoint = currentSailSegment == 0
      ? Coordinates({ x: rosterData.originCoordinatesX, y: rosterData.originCoordinatesY })
      : Coordinates({
        x: sailIntermediatePoints[currentSailSegment - 1].coordinatesX,
        y: sailIntermediatePoints[currentSailSegment - 1].coordinatesY
      });
    Coordinates memory segmentEndPoint = currentSailSegment == sailIntermediatePoints.length
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

    if (updateLocationParams.updatedAt >= segmentEndTime && currentSailSegment == sailIntermediatePoints.length) {
      bool isValid = RouteUtil.isValidPositionUpdateAfterSailDuration(
        segmentEndPoint,
        Coordinates({ x: updatedCoordinatesX, y: updatedCoordinatesY })
      );
      if (!isValid) {
        revert InvalidPositionUpdateAfterSailDuration(
          segmentEndPoint,
          Coordinates({ x: updatedCoordinatesX, y: updatedCoordinatesY })
        );
      }
    } else {
      bool isValid = RouteUtil.isValidPositionUpdate(
        segmentStartPoint,
        segmentEndPoint,
        segmentStartTime,
        segmentEndTime,
        updateLocationParams.updatedAt,
        Coordinates({ x: updatedCoordinatesX, y: updatedCoordinatesY })
      );
      if (!isValid) {
        revert InvalidPositionUpdate(
          segmentStartPoint,
          segmentEndPoint,
          segmentStartTime,
          segmentEndTime,
          updateLocationParams.updatedAt,
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
    e.updateLocationParams = updateLocationParams;
    e.coordinatesUpdatedAt = updateLocationParams.updatedAt;
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
    rosterData.updatedCoordinatesX = rosterLocationUpdated.updateLocationParams.updatedCoordinates.x;
    rosterData.updatedCoordinatesY = rosterLocationUpdated.updateLocationParams.updatedCoordinates.y;

    // Update the timestamp of the last coordinate update
    rosterData.coordinatesUpdatedAt = rosterLocationUpdated.coordinatesUpdatedAt;

    // Update the current sail segment
    rosterData.currentSailSegment = rosterLocationUpdated.updateLocationParams.updatedSailSegment;

    return rosterData;
  }
}
