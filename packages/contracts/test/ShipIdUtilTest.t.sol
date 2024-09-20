// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "forge-std/Test.sol";
import { ShipIdUtil } from "../src/utils/ShipIdUtil.sol";

contract ShipIdUtilTest is Test {
  function testRemoveShipId() public {
    uint256[] memory shipIds = new uint256[](5);
    shipIds[0] = 1;
    shipIds[1] = 2;
    shipIds[2] = 3;
    shipIds[3] = 4;
    shipIds[4] = 5;
    uint256 shipIdToRemove = 3;
    uint256[] memory expectedShipIds = new uint256[](4);
    expectedShipIds[0] = 1;
    expectedShipIds[1] = 2;
    expectedShipIds[2] = 4;
    expectedShipIds[3] = 5;

    uint256[] memory result = ShipIdUtil.removeShipId(shipIds, shipIdToRemove);

    assertEq(result, expectedShipIds, "ShipId removal failed");

    // Test remove a empty shipIds
    // Expect revert
    uint256[] memory emptyShipIds = new uint256[](0);
    vm.expectRevert(ShipIdUtil.EmptyShipIds.selector);
    ShipIdUtil.removeShipId(emptyShipIds, shipIdToRemove);

    // Test remove from shipIds which has only one element
    uint256[] memory singleShipIds = new uint256[](1);
    singleShipIds[0] = 3;
    uint256[] memory expectedEmptyShipIds = new uint256[](0);
    uint256[] memory removeSingleResult = ShipIdUtil.removeShipId(singleShipIds, shipIdToRemove);
    assertEq(removeSingleResult, expectedEmptyShipIds, "ShipId removal failed");

    // Test remove a shipId that not exists
    vm.expectRevert(ShipIdUtil.ShipIdNotFound.selector);
    ShipIdUtil.removeShipId(shipIds, 6);
  }

  function testAddShipId() public {
    uint256[] memory shipIds = new uint256[](5);
    shipIds[0] = 1;
    shipIds[1] = 2;
    shipIds[2] = 3;
    shipIds[3] = 4;
    shipIds[4] = 5;
    uint256[] memory expectedShipIds = new uint256[](6);
    expectedShipIds[0] = 6;
    expectedShipIds[1] = 1;
    expectedShipIds[2] = 2;
    expectedShipIds[3] = 3;
    expectedShipIds[4] = 4;
    expectedShipIds[5] = 5;
    uint256[] memory result = ShipIdUtil.addShipId(shipIds, 6, 0);
    assertEq(result, expectedShipIds, "ShipId addition failed");

    // Test add a shipId to a empty shipIds
    uint256[] memory emptyShipIds = new uint256[](0);
    uint256[] memory addEmptyResult = ShipIdUtil.addShipId(emptyShipIds, 1, 0);
    uint256[] memory expectedAddEmptyResult = new uint256[](1);
    expectedAddEmptyResult[0] = 1;
    assertEq(addEmptyResult, expectedAddEmptyResult, "ShipId addition failed");
  }
}
