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
import { ShipBattleData, ShipBattle, ShipData, Ship, PlayerIdGenerator, ShipIdGenerator, ShipBattleIdGenerator, RosterData, Roster, Player, PlayerData } from "../src/codegen/index.sol";
import { ItemIdQuantityPair } from "../src/systems/ItemIdQuantityPair.sol";
import { RosterUtil } from "../src/utils/RosterUtil.sol";
import { DirectRouteUtil } from "../src/utils/DirectRouteUtil.sol";
import { TwoRostersLocationUpdateParams } from "../src/systems/TwoRostersLocationUpdateParams.sol";
import { Coordinates } from "../src/systems/Coordinates.sol";
import { SpeedUtil } from "../src/utils/SpeedUtil.sol";

contract BugTest is Script {
  //
  // forge script BugTest.s.sol:BugTest --sig "run(address)" 0x593ad505023ea24371f8f628b251e0667308840f --broadcast --rpc-url https://odyssey.storyrpc.io/
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

    // uint256 balance = deployerAddress.balance;
    // console.log("Account balance:", balance);

    IWorld world = IWorld(worldAddress);
    world.app__shipBattleTakeLoot(16, 1);
    vm.stopBroadcast();
  }
}
