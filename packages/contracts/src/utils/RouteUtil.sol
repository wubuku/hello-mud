// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/utils/math/SafeCast.sol";
import "../systems/Coordinates.sol";
import "./DirectRouteUtil.sol";

library RouteUtil {
  uint64 constant ALLOWED_TIME_DEVIATION = 5; // NOTE: 5 seconds, is this a good value?
  uint256 constant MAX_DEVIATION_FROM_ROUTE = 200; // NOTE: 100 distance units, is this a good value?
  uint256 constant MAX_DEVIATION_FROM_EXPECTED = 100; // NOTE: 50 distance units, is this a good value?
  uint256 constant MAX_DEVIATION_FROM_TARGET = MAX_DEVIATION_FROM_ROUTE + MAX_DEVIATION_FROM_EXPECTED / 2;

  function isValidPositionUpdateAfterSailDuration(
    Coordinates memory sailTarget,
    Coordinates memory newPosition
  ) internal pure returns (bool) {
    uint256 deviationFromTarget = DirectRouteUtil.getDistance(newPosition, sailTarget);
    if (deviationFromTarget > MAX_DEVIATION_FROM_TARGET) {
      return false;
    }
    return true;
  }

  function isValidPositionUpdate(
    Coordinates memory segmentStartPoint,
    Coordinates memory segmentEndPoint,
    uint64 segmentStartTime,
    uint64 segmentEndTime,
    uint64 updateTime,
    Coordinates memory newPosition
  ) internal pure returns (bool) {
    // Check if currentTime is within allowed range
    if (
      updateTime + ALLOWED_TIME_DEVIATION < segmentStartTime || updateTime > segmentEndTime + ALLOWED_TIME_DEVIATION
    ) {
      return false;
    }

    // Calculate expected current position
    Coordinates memory expectedPosition = DirectRouteUtil.calculateCurrentPosition(
      segmentStartPoint,
      segmentEndPoint,
      segmentStartTime,
      segmentEndTime,
      updateTime
    );

    // Project new position onto segment
    (, Coordinates memory projectedPosition) = projectPointOnSegment(segmentStartPoint, segmentEndPoint, newPosition);

    //if (!isWithinSegment) { // We intentionally ignore this check
    //  return false;
    //}

    // Calculate deviations
    uint256 deviationFromRoute = DirectRouteUtil.getDistance(newPosition, projectedPosition);
    uint256 deviationFromExpected = DirectRouteUtil.getDistance(projectedPosition, expectedPosition);

    // Check if deviations are within allowed limits
    if (deviationFromRoute > MAX_DEVIATION_FROM_ROUTE || deviationFromExpected > MAX_DEVIATION_FROM_EXPECTED) {
      return false;
    }

    return true;
  }

  /**
   * @notice Projects a point onto a line segment and checks if the projection is within the segment.
   * @param a Coordinates of point A (start of segment)
   * @param b Coordinates of point B (end of segment)
   * @param p Coordinates of point P
   * @return isWithinSegment True if the projection falls on the segment AB, false otherwise
   * @return intersection Coordinates of the intersection point
   */
  function projectPointOnSegment(
    Coordinates memory a,
    Coordinates memory b,
    Coordinates memory p
  ) internal pure returns (bool isWithinSegment, Coordinates memory intersection) {
    // Calculate vectors using SafeCast to prevent overflow
    int256 abX = SafeCast.toInt256(uint256(b.x)) - SafeCast.toInt256(uint256(a.x));
    int256 abY = SafeCast.toInt256(uint256(b.y)) - SafeCast.toInt256(uint256(a.y));
    int256 apX = SafeCast.toInt256(uint256(p.x)) - SafeCast.toInt256(uint256(a.x));
    int256 apY = SafeCast.toInt256(uint256(p.y)) - SafeCast.toInt256(uint256(a.y));

    // Calculate dot products with reduced precision to prevent overflow
    int256 prod1 = (apX * abX) / 1e4;  // Reduce precision to prevent overflow
    int256 prod2 = (apY * abY) / 1e4;
    int256 dotProductAP_AB = (prod1 + prod2) * 1e4;

    int256 prod3 = (abX * abX) / 1e4;
    int256 prod4 = (abY * abY) / 1e4;
    int256 dotProductAB_AB = (prod3 + prod4) * 1e4;

    // Handle division by zero case
    if (dotProductAB_AB == 0) {
        intersection = a;
        isWithinSegment = true;
        return (isWithinSegment, intersection);
    }

    // Calculate projection point with reduced precision
    uint256 t = uint256((dotProductAP_AB * 1e5) / dotProductAB_AB);
    
    // Safely calculate final coordinates
    uint256 deltaX = (uint256(abX >= 0 ? abX : -abX) * t) / 1e5;
    uint256 deltaY = (uint256(abY >= 0 ? abY : -abY) * t) / 1e5;
    
    intersection.x = abX >= 0 ? a.x + uint32(deltaX) : a.x - uint32(deltaX);
    intersection.y = abY >= 0 ? a.y + uint32(deltaY) : a.y - uint32(deltaY);

    // Determine if the projection is within the segment
    isWithinSegment = (dotProductAP_AB >= 0 && dotProductAP_AB <= dotProductAB_AB);

    /*
    // Check if the projection falls within the segment AB
    if (dotProductAP_AB >= 0 && dotProductAP_AB <= dotProductAB_AB) {
      uint256 t = uint256((dotProductAP_AB * 1e9) / dotProductAB_AB);
      intersection.x = a.x + uint32((uint256(abX) * t) / 1e9);
      intersection.y = a.y + uint32((uint256(abY) * t) / 1e9);
      isWithinSegment = true;
    } else {
      // Set default values when the projection is not within the segment
      isWithinSegment = false;
      intersection.x = 0;
      intersection.y = 0;
    }
    */

    return (isWithinSegment, intersection);
  }
}
