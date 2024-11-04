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
import { Sea } from "../src/tokens/Sea.sol";

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import { SkillType } from "../src/systems/SkillType.sol";
import { PlayerIdGenerator } from "../src/codegen/index.sol";
import { ItemIdQuantityPair } from "../src/systems/ItemIdQuantityPair.sol";
import { Coordinates } from "../src/systems/Coordinates.sol";

contract DeployTokens is Script {
  function run() external {
    // Specify a store so that you can use tables directly in PostDeploy
    // StoreSwitch.setStoreAddress(worldAddress);

    // Load the private key from the `PRIVATE_KEY` environment variable (in .env)
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    address deployerAddress = vm.addr(deployerPrivateKey);

    // Start broadcasting transactions from the deployer account
    vm.startBroadcast(deployerPrivateKey);

    console.log("Deploying contracts with the account:", deployerAddress);

    uint256 balance = deployerAddress.balance;
    console.log("Account balance:", balance);

    // ************************************************************************************************

    Energy energyToken = new Energy(deployerAddress);
    address energyTokenAddress = address(energyToken);
    console.log("ENERGY Token address:", energyTokenAddress);

    
    Sea seaToken = new Sea(deployerAddress);
    address seaTokenAddress = address(seaToken);
    console.log("Sea Token address:", seaTokenAddress);

    // You need to wait for the creation time to complete...
    // Then execute the ManualSmokeTest script

    vm.stopBroadcast();
  }

  function addIsland(IWorld world, uint32 coordinatesX, uint32 coordinatesY) internal {
    ItemIdQuantityPair[] memory islandResources = createIslandResources();

    console.log("Adding an island to the map at coordinates (%d, %d)", coordinatesX, coordinatesY);
    logIslandResources(islandResources);

    world.app__mapAddIsland(coordinatesX, coordinatesY, islandResources);
    console.log("Island added successfully.");
  }

  function addMultiIslands(
    IWorld world,
    uint32[] memory coordinatesX,
    uint32[] memory coordinatesY,
    uint32 resourceSubtotal
  ) internal {
    Coordinates[] memory multiCoordinates = new Coordinates[](coordinatesX.length);
    for (uint i = 0; i < coordinatesX.length; i++) {
      multiCoordinates[i] = Coordinates(coordinatesX[i], coordinatesY[i]);
    }
    uint32[] memory resourceItemIds = createMultiIslandsResourceIds();
    world.app__mapAddMultiIslands(multiCoordinates, resourceItemIds, resourceSubtotal);
    console.log("Multi-islands added successfully.");
  }

  function createIslandResources() internal pure returns (ItemIdQuantityPair[] memory) {
    ItemIdQuantityPair[] memory resources = new ItemIdQuantityPair[](3);
    resources[0] = ItemIdQuantityPair(2, 200); // CottonSeeds
    resources[1] = ItemIdQuantityPair(2000000001, 100); // ResourceTypeWoodcutting
    resources[2] = ItemIdQuantityPair(2000000003, 200); // ResourceTypeMining
    return resources;
  }
  

  function createMultiIslandsResourceIds() internal pure returns (uint32[] memory) {
    uint32[] memory resourceItemIds = new uint32[](3);
    resourceItemIds[0] = 2; // CottonSeeds
    resourceItemIds[1] = 2000000001; // ResourceTypeWoodcutting
    resourceItemIds[2] = 2000000003; // ResourceTypeMining
    return resourceItemIds;
  }

  function logIslandResources(ItemIdQuantityPair[] memory resources) internal view {
    console.log("With the following resources:");
    for (uint i = 0; i < resources.length; i++) {
      console.log("    ItemId: %d, Quantity: %d", resources[i].itemId, resources[i].quantity);
    }
  }

  function createItems(IWorld world) internal {
    world.app__itemCreate(0, false, 1, "UNUSED_ITEM");
    world.app__itemCreate(1, false, 1, "PotatoSeeds");
    world.app__itemCreate(101, true, 1, "Potatoes");
    world.app__itemCreate(2, true, 5, "CottonSeeds");
    world.app__itemCreate(102, true, 1, "Cottons");
    world.app__itemCreate(1001, true, 1, "BronzeBar");
    world.app__itemCreate(200, true, 1, "NormalLogs");
    world.app__itemCreate(1000000001, true, 1, "Ship");
    world.app__itemCreate(301, true, 1, "CopperOre");
    world.app__itemCreate(302, true, 1, "TinOre");
    world.app__itemCreate(2000000001, true, 1, "ResourceTypeWoodcutting");
    world.app__itemCreate(2000000002, true, 1, "ResourceTypeFishing");
    world.app__itemCreate(2000000003, true, 1, "ResourceTypeMining");
  }

  function createItemCreations(IWorld world) internal {
    // Mining
    world.app__itemCreationCreate(
      uint8(SkillType.MINING), // skillType (mining)
      301, // itemId (CopperOre)
      1, // requirementsLevel
      1, // baseQuantity
      0, // baseExperience
      3, // baseCreationTime 
      1*10**18, // energyCost
      100, // successRate
      1 // resourceCost
    );

    // Woodcutting
    world.app__itemCreationCreate(
      uint8(SkillType.WOODCUTTING), // skillType (woodcutting)
      200, // itemId (NormalLogs)
      1, // requirementsLevel
      1, // baseQuantity
      0, // baseExperience
      3, // baseCreationTime
      1*10**18, // energyCost
      100, // successRate
      1 // resourceCost
    );
  }

  function createItemProductions(IWorld world) internal {
    // Farming (Cotton Seeds to Cotton)
    uint32[] memory cottonMaterialItemIds = new uint32[](1);
    cottonMaterialItemIds[0] = 2; // ItemCottonSeeds.ItemId

    uint32[] memory cottonMaterialItemQuantities = new uint32[](1);
    cottonMaterialItemQuantities[0] = 1;

    world.app__itemProductionCreate(
      uint8(SkillType.FARMING), // skillType (farming)
      102, // itemId (Cottons)
      1, // requirementsLevel
      1, // baseQuantity
      0, // baseExperience
      15, // baseCreationTime
      5*10**18, // energyCost
      100, // successRate
      cottonMaterialItemIds,
      cottonMaterialItemQuantities
    );

    // Ship crafting
    uint32[] memory shipMaterialItemIds = new uint32[](3);
    shipMaterialItemIds[0] = 102; // Cottons
    shipMaterialItemIds[1] = 200; // NormalLogs
    shipMaterialItemIds[2] = 301; // CopperOre

    uint32[] memory shipMaterialItemQuantities = new uint32[](3);
    shipMaterialItemQuantities[0] = 3; // 3 Cottons
    shipMaterialItemQuantities[1] = 3; // 3 NormalLogs
    shipMaterialItemQuantities[2] = 3; // 3 CopperOre

    world.app__itemProductionCreate(
      uint8(SkillType.CRAFTING),
      1000000001, // itemId (Ship)
      1, // requirementsLevel
      1, // baseQuantity
      0, // baseExperience (adjusted to 0 as per the script)
      15, // baseCreationTime
      5*10**18, // energyCost (adjusted to match the script)
      100, // successRate
      shipMaterialItemIds,
      shipMaterialItemQuantities
    );
  }
}
