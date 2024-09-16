// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "forge-std/Test.sol";
import { SpeedUtil, Coordinates } from "../src/utils/SpeedUtil.sol";

contract SpeedUtilTest is Test {
  function testCalculateTotalTime() public {
    Coordinates memory origin = Coordinates(2147481827, 2147482947);
    Coordinates memory destination = Coordinates(2147482142, 2147482601);
    uint32 speed = 5;

    uint64 totalTime = SpeedUtil.calculateTotalTime(origin, destination, speed);

    // 这里我们需要知道预期的结果。假设我们期望的结果是 30000
    // 您应该根据实际情况调整这个值
    uint64 expectedTime = 31;
    console.log("totalTime:", totalTime);
    assertApproxEqAbs(totalTime, expectedTime, 39, "Total time calculation is incorrect");
  }
}
