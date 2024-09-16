// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "forge-std/Test.sol";
import { DirectRouteUtil, Coordinates } from "../src/utils/DirectRouteUtil.sol";

contract DirectRouteUtilTest is Test {
  function setUp() public {
    // 如果需要任何设置，可以在这里进行
  }

  function testGetDistance() public {
    Coordinates memory origin = Coordinates(2147496697, 2147487097);
    Coordinates memory destination = Coordinates(214741783, 214741570);

    uint256 distance = DirectRouteUtil.getDistance(origin, destination);

    // 使用近似值比较，因为我们使用了平方根
    assertApproxEqAbs(distance, 2733321574, 1);

    console.log("Distance:", distance);
  }

  function testGetDistanceZero() public {
    Coordinates memory point = Coordinates(0, 0);

    uint256 distance = DirectRouteUtil.getDistance(point, point);

    assertEq(distance, 0);
  }
}
