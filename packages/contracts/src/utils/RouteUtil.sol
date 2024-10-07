// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "@openzeppelin/contracts/utils/math/Math.sol";
import "../systems/Coordinates.sol";
import "./DirectRouteUtil.sol";

library RouteUtil {
  uint64 constant ALLOWED_TIME_DEVIATION = 5; // NOTE: 5 seconds, is this a good value?
  uint256 constant MAX_DEVIATION_FROM_ROUTE = 100; // NOTE: 100 distance units, is this a good value?
  uint256 constant MAX_DEVIATION_FROM_EXPECTED = 50; // NOTE: 50 distance units, is this a good value?

  function isValidPositionUpdate(
    Coordinates memory segmentStart,
    Coordinates memory segmentEnd,
    uint64 segmentStartTime,
    uint64 segmentEndTime,
    uint64 currentTime,
    Coordinates memory newPosition
  ) internal pure returns (bool) {
    // Check if currentTime is within allowed range
    if (
      currentTime < segmentStartTime - ALLOWED_TIME_DEVIATION || currentTime > segmentEndTime + ALLOWED_TIME_DEVIATION
    ) {
      return false;
    }

    // Calculate expected current position
    Coordinates memory expectedPosition = DirectRouteUtil.calculateCurrentPosition(
      segmentStart,
      segmentEnd,
      segmentStartTime,
      segmentEndTime,
      currentTime
    );

    // Project new position onto segment
    (, Coordinates memory projectedPosition) = projectPointOnSegment(
      segmentStart,
      segmentEnd,
      newPosition
    );

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
   * @notice Determines if the orthogonal projection of point P onto line AB falls within the segment AB
   * @param a Coordinates of point A (start of segment)
   * @param b Coordinates of point B (end of segment)
   * @param p Coordinates of point P
   * @return isWithinSegment True if the projection falls on the segment AB, false otherwise
   * @return intersection Coordinates of the intersection point (only valid if isWithinSegment is true)
   */
  function projectPointOnSegment(
    Coordinates memory a,
    Coordinates memory b,
    Coordinates memory p
  ) internal pure returns (bool isWithinSegment, Coordinates memory intersection) {
    // Calculate vectors
    int256 abX = int256(uint256(b.x)) - int256(uint256(a.x));
    int256 abY = int256(uint256(b.y)) - int256(uint256(a.y));
    int256 apX = int256(uint256(p.x)) - int256(uint256(a.x));
    int256 apY = int256(uint256(p.y)) - int256(uint256(a.y));

    // Calculate dot products
    int256 dotProductAP_AB = apX * abX + apY * abY;
    int256 dotProductAB_AB = abX * abX + abY * abY;

    // Calculate the projection point regardless of whether it's on the segment
    uint256 t = uint256((dotProductAP_AB * 1e18) / dotProductAB_AB);
    intersection.x = a.x + uint32((uint256(abX) * t) / 1e18);
    intersection.y = a.y + uint32((uint256(abY) * t) / 1e18);

    // Determine if the projection is within the segment
    isWithinSegment = (dotProductAP_AB >= 0 && dotProductAP_AB <= dotProductAB_AB);

    /*
    // Check if the projection falls within the segment AB
    if (dotProductAP_AB >= 0 && dotProductAP_AB <= dotProductAB_AB) {
      uint256 t = uint256((dotProductAP_AB * 1e18) / dotProductAB_AB);
      intersection.x = a.x + uint32((uint256(abX) * t) / 1e18);
      intersection.y = a.y + uint32((uint256(abY) * t) / 1e18);
      isWithinSegment = true;
    } else {
      // Set default values when the projection is not within the segment
      isWithinSegment = false;
      intersection.x = 0;
      intersection.y = 0;
    }
    */
  }
}
