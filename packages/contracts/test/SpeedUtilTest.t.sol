// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "forge-std/Test.sol";
import { SpeedUtil, Coordinates } from "../src/utils/SpeedUtil.sol";

// import { RosterUtil } from "../src/utils/RosterUtil.sol";

contract SpeedUtilTest is Test {
  function testcalculateDirectRouteDuration() public {
    Coordinates memory origin = Coordinates(2147481827, 2147482947);
    Coordinates memory destination = Coordinates(2147482142, 2147482601);
    uint32 speed = 5;

    uint64 totalTime = SpeedUtil.calculateDirectRouteDuration(origin, destination, speed);

    uint64 expectedTime = 31;
    console.log("totalTime:", totalTime);
    assertApproxEqAbs(totalTime, expectedTime, 39, "Total time calculation is incorrect");

    // //////////////////////////////////////////////////////////////
    uint32 firstIslandX = 2147483647;
    uint32 firstIslandY = 2147483647;
    // app__rosterSetSail(1, 1,
    // 2147483807 [2.147e9], 2147485457 [2.147e9], 2,
    // 2147483647 [2.147e9], 2147483647 [2.147e9])
    uint32 currentRosterSequenceNumber = 1;
    // (uint32 originCoordinatesX, uint32 originCoordinatesY) = RosterUtil.getRosterOriginCoordinates(
    //   firstIslandX,
    //   firstIslandY,
    //   currentRosterSequenceNumber
    // );
    uint32 originCoordinatesX = 2147483647;
    uint32 originCoordinatesY = 2147483647;
    uint32 targetCoordinatesX = 2147483807; //originCoordinatesX + 10;
    uint32 targetCoordinatesY = 2147485457; // originCoordinatesY + 10;

    uint64 totalTime2 = SpeedUtil.calculateDirectRouteDuration(
      Coordinates(originCoordinatesX, originCoordinatesY),
      Coordinates(targetCoordinatesX, targetCoordinatesY),
      5
    );
    console.log("totalTime2:", totalTime2);
  }
}
