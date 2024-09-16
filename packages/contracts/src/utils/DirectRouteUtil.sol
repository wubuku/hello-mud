// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "@openzeppelin/contracts/utils/math/Math.sol";
import "../systems/Coordinates.sol";

library DirectRouteUtil {
  function getDistance(Coordinates memory origin, Coordinates memory destination) internal pure returns (uint256) {
    uint256 xDiff = origin.x > destination.x ? origin.x - destination.x : destination.x - origin.x;
    uint256 yDiff = origin.y > destination.y ? origin.y - destination.y : destination.y - origin.y;
    return Math.sqrt(xDiff * xDiff + yDiff * yDiff);
  }
}
