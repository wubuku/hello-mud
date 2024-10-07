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

contract CreatePlayerTest is Script {
  //
  // forge script script/GatherIslandResourcesTest.s.sol:GatherIslandResourcesTest --sig "run(address)" <WORLD_ADDRESS> --broadcast --rpc-url http://localhost:8545
  //
  function run(address worldAddress) external {
    // Specify a store so that you can use tables directly in PostDeploy
    StoreSwitch.setStoreAddress(worldAddress);

    // Load the private key from the `PRIVATE_KEY` environment variable (in .env)
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_2");
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
    // world.app__energyTokenCreate(energyTokenAddress);
    // console.log("Set ENERGY token address for the world");
    world.app__playerCreate("TestPlayer2");
    uint256 playerId = PlayerIdGenerator.getId();
    console.log("Created test player, playerId:", playerId);

    uint32 secondIslandX = 2147483647 + 10000;
    uint32 secondIslandY = 2147483647 + 10000;
    world.app__playerClaimIsland(playerId, secondIslandX, secondIslandY);
    console.log("An island claimed by test player");

    vm.stopBroadcast();
  }
}
