// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "../utils/DirectRouteUtil.sol";
import "../systems/Coordinates.sol";

library SpeedUtil {
  uint32 constant STANDARD_SPEED_NUMERATOR = 235680;
  uint32 constant STANDARD_SPEED_DENOMINATOR = 1000;
  uint32 constant SPEED_NUMERATOR_DELTA = 23568;

  // Remove SafeMath usage
  // using SafeMath for uint256;
  // using SafeMath for int256;

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

  function calculateDirectRouteCurrentPosition(
    uint32 speedProperty,
    Coordinates memory startCoordinates,
    Coordinates memory targetCoordinates,
    uint64 elapsedTime
  ) internal pure returns (Coordinates memory currentPosition) {
    (uint32 speedNumerator, uint32 speedDenominator) = speedPropertyToCoordinateUnitsPerSecond(speedProperty);
    uint256 distanceTraveled = (uint256(speedNumerator) * elapsedTime) / uint256(speedDenominator);

    uint256 totalDistance = DirectRouteUtil.getDistance(startCoordinates, targetCoordinates);

    if (totalDistance == 0) {
      return startCoordinates;
    }

    // Use unchecked for gas optimization, as we're sure these operations won't overflow
    unchecked {
      int256 deltaX = int256(uint256(targetCoordinates.x)) - int256(uint256(startCoordinates.x));
      int256 deltaY = int256(uint256(targetCoordinates.y)) - int256(uint256(startCoordinates.y));

      int256 currentX = int256(uint256(startCoordinates.x)) +
        (deltaX * int256(distanceTraveled)) /
        int256(totalDistance);
      int256 currentY = int256(uint256(startCoordinates.y)) +
        (deltaY * int256(distanceTraveled)) /
        int256(totalDistance);

      // Ensure the result is within uint32 range
      require(currentX >= 0 && currentX <= int256(uint256(type(uint32).max)), "X coordinate out of bounds");
      require(currentY >= 0 && currentY <= int256(uint256(type(uint32).max)), "Y coordinate out of bounds");

      return Coordinates(uint32(uint256(currentX)), uint32(uint256(currentY)));
    }
  }
}
