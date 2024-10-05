// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "forge-std/Test.sol";
import { DirectRouteUtil, Coordinates } from "../src/utils/DirectRouteUtil.sol";

contract DirectRouteUtilTest is Test {
  function setUp() public {
    //
  }

  function testGetDistance() public {
    Coordinates memory origin = Coordinates(2147496697, 2147487097);
    Coordinates memory destination = Coordinates(214741783, 214741570);

    uint256 distance = DirectRouteUtil.getDistance(origin, destination);

    // Use approximate comparison because we are using square root
    assertApproxEqAbs(distance, 2733321574, 1);

    console.log("Distance:", distance);
  }

  function testGetDistanceZero() public {
    Coordinates memory point = Coordinates(0, 0);

    uint256 distance = DirectRouteUtil.getDistance(point, point);

    assertEq(distance, 0);
  }
}
