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
}
