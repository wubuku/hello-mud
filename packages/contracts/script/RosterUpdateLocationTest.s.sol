// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { Systems } from "@latticexyz/world/src/codegen/tables/Systems.sol";
import { ResourceId, WorldResourceIdLib } from "@latticexyz/world/src/WorldResourceId.sol";
import { RESOURCE_SYSTEM } from "@latticexyz/world/src/worldResourceTypes.sol";

import { IWorld } from "../src/codegen/world/IWorld.sol";
import { Energy } from "../src/tokens/Energy.sol";

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import { SkillType } from "../src/systems/SkillType.sol";
import { SailIntPointData, PlayerIdGenerator, ShipIdGenerator, ShipBattleIdGenerator, RosterData, Roster } from "../src/codegen/index.sol";
import { ItemIdQuantityPair } from "../src/systems/ItemIdQuantityPair.sol";
import { RosterUtil } from "../src/utils/RosterUtil.sol";
import { SpeedUtil } from "../src/utils/SpeedUtil.sol";
import { Coordinates } from "../src/systems/Coordinates.sol";
import { UpdateLocationParams } from "../src/systems/UpdateLocationParams.sol";

import { SailIntPointLib } from "../src/systems/SailIntPointLib.sol";

contract RosterUpdateLocationTest is Script {
  //
  // forge script RosterUpdateLocationTest.s.sol:RosterUpdateLocationTest --sig "run(address)" 0x776086899eab4ee3953b7c037b2c0a13c7a1deed --broadcast --rpc-url https://odyssey.storyrpc.io/
  //
  function run(address worldAddress) external {
    // Specify a store so that you can use tables directly in PostDeploy
    StoreSwitch.setStoreAddress(worldAddress);

    // Load the private key from the `PRIVATE_KEY` environment variable (in .env)
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    address deployerAddress = vm.addr(deployerPrivateKey);

    // Start broadcasting transactions from the deployer account
    vm.startBroadcast(deployerPrivateKey);

    console.log("Current account:", deployerAddress);

    uint256 balance = deployerAddress.balance;
    console.log("Account balance:", balance);

    // Energy energyToken = new Energy(deployerAddress);
    // address energyTokenAddress = address(energyToken);
    // console.log("ENERGY Token address:", energyTokenAddress);

    // IERC20 energyIErc20 = IERC20(energyTokenAddress);
    // energyIErc20.approve(systemAddress, 10000 * 10 ** 18);
    // console.log("Approved AggregatorServiceSystem to spend ENERGY tokens");

    IWorld world = IWorld(worldAddress);
    uint256 currentTimestamp = block.timestamp;
    console.log("Current timestamp:", currentTimestamp);

    uint32 playerId = 1;
    uint32 currentRosterSequenceNumber = 1;
    RosterData memory rosterData = Roster.get(playerId, currentRosterSequenceNumber);
    console.log("Roster speed:", rosterData.speed);
    console.log("Roster origin coordinates:", rosterData.originCoordinatesX, rosterData.originCoordinatesY);
    console.log("Roster set sail at:", rosterData.setSailAt);
    console.log("Roster sail duration:", rosterData.sailDuration);
    SailIntPointData[] memory sailIntermediatePoints = SailIntPointLib.getAllSailIntermediatePoints(
      playerId,
      currentRosterSequenceNumber
    );
    if (sailIntermediatePoints.length > 0) {
      console.log("The roster has %d IntermediatePoints", sailIntermediatePoints.length);
      for (uint i = 0; i < sailIntermediatePoints.length; i++) {
        console.log(
          "coordinatesX:%d,coordinatesY:%d,SegmentShouldStartAt:%d",
          sailIntermediatePoints[i].coordinatesX,
          sailIntermediatePoints[i].coordinatesY,
          sailIntermediatePoints[i].segmentShouldStartAt
        );
      }
    } else {
      console.log("The roster has not IntermediatePoints");
    }

    uint64 elapsedTime = uint64(currentTimestamp - rosterData.setSailAt);
    console.log("Elapsed sail time:", elapsedTime);
    Coordinates memory currentPosition = SpeedUtil.calculateDirectRouteCurrentPosition(
      rosterData.speed,
      Coordinates(rosterData.originCoordinatesX, rosterData.originCoordinatesY),
      Coordinates(rosterData.targetCoordinatesX, rosterData.targetCoordinatesY),
      elapsedTime
    );
    console.log("Current position:", currentPosition.x, currentPosition.y);
    uint16 currentSegment = 0;
    if (elapsedTime > rosterData.sailDuration / 3) {
      currentSegment = 1;
    }
    if (elapsedTime > (rosterData.sailDuration / 3) * 2) {
      currentSegment = 2;
    }
    console.log("Current segment:", currentSegment);
    if (elapsedTime > rosterData.sailDuration) {
      currentPosition = Coordinates(rosterData.targetCoordinatesX, rosterData.targetCoordinatesY);
    }

    UpdateLocationParams memory updateLocationParams;
    updateLocationParams.updatedCoordinates = currentPosition;
    updateLocationParams.updatedSailSegment = currentSegment;
    updateLocationParams.updatedAt = uint64(currentTimestamp);

    world.app__uniApiRosterUpdateLocation(playerId, currentRosterSequenceNumber, updateLocationParams);
    console.log("Roster updated location");

    vm.stopBroadcast();
  }
}
