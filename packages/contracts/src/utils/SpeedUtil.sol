// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "../utils/DirectRouteUtil.sol";
import "../systems/Coordinates.sol";

library SpeedUtil {
  uint32 constant STANDARD_SPEED_NUMERATOR = 23568;
  uint32 constant STANDARD_SPEED_DENOMINATOR = 1000;
  uint32 constant SPEED_NUMERATOR_DELTA = 2356;

  function speedPropertyToCoordinateUnitsPerSecond(uint32 speedProperty) internal pure returns (uint32, uint32) {
    uint32 numerator = STANDARD_SPEED_NUMERATOR;
    uint32 denominator = STANDARD_SPEED_DENOMINATOR;
    if (speedProperty < 5) {
      numerator = numerator - SPEED_NUMERATOR_DELTA * (5 - speedProperty);
    } else {
      numerator = numerator + SPEED_NUMERATOR_DELTA * (speedProperty - 5);
    }
    return (numerator, denominator);
  }

  function calculateSailDurationAndSegments(
    uint32 speed,
    Coordinates memory startCoordinates,
    Coordinates memory targetCoordinates,
    Coordinates[] memory intermediatePoints
  ) internal pure returns (uint64 totalDuration, uint64[] memory segmentDurations) {
    Coordinates memory lastCoordinates = startCoordinates;
    segmentDurations = new uint64[](intermediatePoints.length);

    for (uint256 i = 0; i < intermediatePoints.length; i++) {
      uint64 segmentDuration = calculateDirectRouteDuration(lastCoordinates, intermediatePoints[i], speed);
      segmentDurations[i] = segmentDuration;
      totalDuration += segmentDuration;
      lastCoordinates = intermediatePoints[i];
    }

    totalDuration += calculateDirectRouteDuration(lastCoordinates, targetCoordinates, speed);
  }

  function calculateDirectRouteDuration(
    Coordinates memory origin,
    Coordinates memory destination,
    uint32 speedProperty
  ) internal pure returns (uint64) {
    uint256 distance = DirectRouteUtil.getDistance(origin, destination);
    (uint32 speedNumerator, uint32 speedDenominator) = speedPropertyToCoordinateUnitsPerSecond(speedProperty);
    uint64 totalTime = uint64((distance * uint256(speedDenominator)) / uint256(speedNumerator));
    return totalTime;
  }
}
