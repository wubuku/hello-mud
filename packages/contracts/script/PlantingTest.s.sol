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
import { PlayerIdGenerator, ShipIdGenerator, ShipBattleIdGenerator, RosterData, Roster,AccountPlayer } from "../src/codegen/index.sol";
import { ItemIdQuantityPair } from "../src/systems/ItemIdQuantityPair.sol";
import { RosterUtil } from "../src/utils/RosterUtil.sol";
import { EnergyToken, ItemCreationData, ItemCreation, ItemProductionData, ItemProduction } from "../src/codegen/index.sol";


import { Coordinates } from "../src/systems/Coordinates.sol";
import { ShipBattleLocationParams } from "../src/systems/ShipBattleLocationParams.sol";
import { IAppSystemErrors } from "../src/systems/IAppSystemErrors.sol";
import { PlayerInventoryUpdateUtil } from "../src/utils/PlayerInventoryUpdateUtil.sol";

contract PlantingTest is Script , IAppSystemErrors{
  //
  // forge script script/PlantingTest.s.sol:PlantingTest --sig "run(address)" <WORLD_ADDRESS> --broadcast --rpc-url http://localhost:8545
  //
  function run(address worldAddress) external {

    console.log("worldAddress:",worldAddress);
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


    IWorld world = IWorld(worldAddress);
    uint256 playerId = AccountPlayer.get(deployerAddress);
    console.log("Player Id:",playerId);
    if(playerId<=0){
      revert PlayerDoesNotExist(playerId);
    }

    uint32 cottonSeedsItemId=2;
    uint32 cottonItemId=102;
    uint32 beforeFarmingCottonSeedsQuantity= PlayerInventoryUpdateUtil.getItemQuantity(playerId, cottonSeedsItemId);
    console.log("Before farming,cotton seeds quantity:",beforeFarmingCottonSeedsQuantity);
    uint8 skillProcessSequenceNumber = 1;



    uint32 batchSize=1;

    ItemProductionData memory itemProductionData = ItemProduction.get(SkillType.FARMING, cottonItemId);
    console.log("itemProductionData.energyCost:",itemProductionData.energyCost);
    uint256 energyCost = itemProductionData.energyCost * batchSize;
    console.log("itemProductionData.energyCost * batchSize=",energyCost);


    world.app__uniApiStartProduction(SkillType.FARMING, playerId, skillProcessSequenceNumber, cottonItemId, batchSize); // Cotton
    console.log("Started farming of 1 Cotton");    
    uint32 afterFarmingCottonSeedsQuantity= PlayerInventoryUpdateUtil.getItemQuantity(playerId, cottonSeedsItemId);
    console.log("After farming,cotton seeds quantity:",afterFarmingCottonSeedsQuantity);
    if(beforeFarmingCottonSeedsQuantity-afterFarmingCottonSeedsQuantity!=batchSize){
      console.log("After farming,cotton seeds quantity error");
    }
    // world.app__skillProcessCompleteProduction(uint8(SkillType.FARMING), playerId, sequenceNumber);
    // console.log("Completed skill process production for FARMING");

    vm.stopBroadcast();
  }
}
