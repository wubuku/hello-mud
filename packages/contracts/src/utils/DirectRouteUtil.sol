// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "@openzeppelin/contracts/utils/math/Math.sol";
import "../systems/Coordinates.sol";

library DirectRouteUtil {
  function getDistance(Coordinates memory origin, Coordinates memory destination) internal pure returns (uint256) {
    return getDistance(origin.x, origin.y, destination.x, destination.y);
  }

  function getDistance(uint32 x1, uint32 y1, uint32 x2, uint32 y2) internal pure returns (uint256) {
    uint256 xDiff = x1 > x2 ? x1 - x2 : x2 - x1;
    uint256 yDiff = y1 > y2 ? y1 - y2 : y2 - y1;
    return Math.sqrt(xDiff * xDiff + yDiff * yDiff);
  }

  /**
   * @notice Calculates the distance from a point to a line defined by two points
   * @param a The first point defining the line
   * @param b The second point defining the line
   * @param p The point to calculate the distance from
   * @return The distance from point p to the line defined by points a and b
   */
  function distanceFromPointToLine(
    Coordinates memory a,
    Coordinates memory b,
    Coordinates memory p
  ) internal pure returns (uint256) {
    return distanceFromPointToLine(a.x, a.y, b.x, b.y, p.x, p.y);
  }

  /**
   * @notice Calculates the distance from a point to a line defined by two points
   * @param aX The x-coordinate of the first point defining the line
   * @param aY The y-coordinate of the first point defining the line
   * @param bX The x-coordinate of the second point defining the line
   * @param bY The y-coordinate of the second point defining the line
   * @param pX The x-coordinate of the point to calculate the distance from
   * @param pY The y-coordinate of the point to calculate the distance from
   * @return The distance from point p to the line defined by points a and b
   */
  function distanceFromPointToLine(
    uint32 aX,
    uint32 aY,
    uint32 bX,
    uint32 bY,
    uint32 pX,
    uint32 pY
  ) internal pure returns (uint256) {
    // Calculate vector AB
    int256 abX = int256(uint256(bX)) - int256(uint256(aX));
    int256 abY = int256(uint256(bY)) - int256(uint256(aY));

    // Calculate vector AP
    int256 apX = int256(uint256(pX)) - int256(uint256(aX));
    int256 apY = int256(uint256(pY)) - int256(uint256(aY));

    // Calculate the cross product of AB and AP
    int256 crossProduct = abX * apY - abY * apX;

    // Calculate the length of vector AB
    uint256 lengthAB = Math.sqrt(uint256(abX * abX + abY * abY));

    // Use absolute value for the cross product
    uint256 absCrossProduct = uint256(crossProduct >= 0 ? crossProduct : -crossProduct);

    // Calculate the distance from point P to line AB
    return absCrossProduct / lengthAB;
  }
}
