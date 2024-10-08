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
import { PlayerIdGenerator, ShipIdGenerator, ShipBattleIdGenerator, RosterData, Roster } from "../src/codegen/index.sol";
import { ItemIdQuantityPair } from "../src/systems/ItemIdQuantityPair.sol";
import { RosterUtil } from "../src/utils/RosterUtil.sol";
import { SpeedUtil } from "../src/utils/SpeedUtil.sol";
import { Coordinates } from "../src/systems/Coordinates.sol";

contract RosterSetSailTest is Script {
  //
  // forge script script/RosterSetSailTest.s.sol:RosterSetSailTest --sig "run(address)" <WORLD_ADDRESS> --broadcast --rpc-url http://localhost:8545
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

    // uint32 firstIslandX = 2147483647;
    // uint32 firstIslandY = 2147483647;
    // uint32 currentRosterSequenceNumber = 1;
    // (uint32 originCoordinatesX, uint32 originCoordinatesY) = RosterUtil.getRosterOriginCoordinates(
    //   firstIslandX,
    //   firstIslandY,
    //   currentRosterSequenceNumber
    // );
    uint32 originCoordinatesX = rosterData.updatedCoordinatesX;
    uint32 originCoordinatesY = rosterData.updatedCoordinatesY;
    console.log("Roster origin coordinates:", originCoordinatesX, originCoordinatesY);

    uint32 sailDistanceStep = 300; // abount 60 seconds
    uint32 targetCoordinatesX = originCoordinatesX + sailDistanceStep * 3;
    uint32 targetCoordinatesY = originCoordinatesY + sailDistanceStep * 3;
    Coordinates[] memory intermediatePoints = new Coordinates[](2);
    intermediatePoints[0] = Coordinates(originCoordinatesX + sailDistanceStep, originCoordinatesY + sailDistanceStep);
    intermediatePoints[1] = Coordinates(
      originCoordinatesX + sailDistanceStep * 2,
      originCoordinatesY + sailDistanceStep * 2
    );
    (uint64 sailDuration, uint64[] memory segmentDurations) = SpeedUtil.calculateSailDurationAndSegments(
      rosterData.speed,
      Coordinates(originCoordinatesX, originCoordinatesY),
      Coordinates(targetCoordinatesX, targetCoordinatesY),
      intermediatePoints
    );
    console.log("Sail duration:", sailDuration);
    world.app__rosterSetSail(
      playerId,
      currentRosterSequenceNumber,
      targetCoordinatesX,
      targetCoordinatesY,
      sailDuration,
      originCoordinatesX,
      originCoordinatesY,
      0,
      intermediatePoints
    );
    console.log("Set sail a roster to target coordinates:", targetCoordinatesX, targetCoordinatesY);

    vm.stopBroadcast();
  }
}
