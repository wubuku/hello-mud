// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "forge-std/Test.sol";
import { DirectRouteUtil, Coordinates } from "../src/utils/DirectRouteUtil.sol";

contract PointToLineDistanceFromTest is Test {
  function setUp() public {
    //
  }

  function testParallelLine() public {
    // Line AB is parallel to the x-axis
    uint32 aX = 0;
    uint32 aY = 0;
    uint32 bX = 10;
    uint32 bY = 0;
    uint32 pX = 5;
    uint32 pY = 5;

    uint256 distance = DirectRouteUtil.distanceFromPointToLine(aX, aY, bX, bY, pX, pY);
    assertEq(distance, 5, "Distance should be 5 for a parallel line");
  }

  function testVerticalLine() public {
    // Line AB is vertical
    uint32 aX = 0;
    uint32 aY = 0;
    uint32 bX = 0;
    uint32 bY = 10;
    uint32 pX = 5;
    uint32 pY = 5;

    uint256 distance = DirectRouteUtil.distanceFromPointToLine(aX, aY, bX, bY, pX, pY);
    assertEq(distance, 5, "Distance should be 5 for a vertical line");
  }

  function testPointOnLine() public {
    // Point P is on the line AB
    uint32 aX = 0;
    uint32 aY = 0;
    uint32 bX = 10;
    uint32 bY = 10;
    uint32 pX = 5;
    uint32 pY = 5;

    uint256 distance = DirectRouteUtil.distanceFromPointToLine(aX, aY, bX, bY, pX, pY);
    assertEq(distance, 0, "Distance should be 0 when point is on the line");
  }

  function test45DegreeLine() public {
    // Line AB is at a 45-degree angle
    uint32 aX = 0;
    uint32 aY = 0;
    uint32 bX = 1000000000;
    uint32 bY = 1000000000;
    uint32 pX = 500000000;
    uint32 pY = 0;

    uint256 distance = DirectRouteUtil.distanceFromPointToLine(aX, aY, bX, bY, pX, pY);
    uint256 scaledNumerator = 500000000 * 1e18; // Adjust scaling to match precision
    uint256 scaledDenominator = 1414213562373095048; // Adjust denominator to match precision
    uint256 expectedDistance = scaledNumerator / scaledDenominator;
    console.log("Distance:", distance);
    assertApproxEqAbs(distance, expectedDistance, 1);
  }

  function test30DegreeLine() public {
    // Line AB is at a 30-degree angle
    uint32 aX = 0;
    uint32 aY = 0;
    uint32 bX = 1000;
    uint32 bY = 577; // 1000 * tan(30 degrees) for precision

    // Points on the 60-degree line
    uint32[2][] memory points = new uint32[2][](3);
    points[0] = [uint32(1000), uint32(1732)]; // (1000, sqrt(3) * 1000)
    points[1] = [uint32(2000), uint32(3464)]; // (2000, 2 * sqrt(3) * 1000)
    points[2] = [uint32(3000), uint32(5196)]; // (3000, 3 * sqrt(3) * 1000)

    for (uint i = 0; i < points.length; i++) {
      uint32 pX = points[i][0];
      uint32 pY = points[i][1];

      uint256 distance = DirectRouteUtil.distanceFromPointToLine(aX, aY, bX, bY, pX, pY);
      uint256 expectedDistance = uint256((i + 1) * 1000); // Distance formula for 30 and 60 degree lines
      assertApproxEqAbs(
        distance,
        expectedDistance,
        1 * (i + 1),
        "Distance should match expected value for 30-degree line"
      );
    }
  }
}
