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

import { PlayerIdGenerator } from "../src/codegen/index.sol";

contract PostDeploy is Script {
  function run(address worldAddress) external {
    // Specify a store so that you can use tables directly in PostDeploy
    StoreSwitch.setStoreAddress(worldAddress);

    // Load the private key from the `PRIVATE_KEY` environment variable (in .env)
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    address deployerAddress = vm.addr(deployerPrivateKey);

    // Start broadcasting transactions from the deployer account
    vm.startBroadcast(deployerPrivateKey);

    console.log("Deploying contracts with the account:", deployerAddress);

    uint256 balance = deployerAddress.balance;
    console.log("Account balance:", balance);

    Energy energyToken = new Energy(deployerAddress);
    address energyTokenAddress = address(energyToken);
    console.log("ENERGY Token address:", energyTokenAddress);

    ResourceId skillProcessServiceSystemId = WorldResourceIdLib.encode({
      typeId: RESOURCE_SYSTEM,
      namespace: "app",
      name: "AggregatorServic" // NOTE: Only the first 16 characters are used. Original: "AggregatorServiceSystem"
    });
    (address systemAddress, bool publicAccess) = Systems.get(skillProcessServiceSystemId);
    console.log("AggregatorServiceSystem address:", systemAddress);
    console.log("AggregatorServiceSystem publicAccess:", publicAccess);

    IERC20 energyIErc20 = IERC20(energyTokenAddress);
    energyIErc20.approve(systemAddress, 10000 * 10 ** 18);
    console.log("Approved AggregatorServiceSystem to spend ENERGY tokens");

    IWorld world = IWorld(worldAddress);
    world.app__energyTokenCreate(energyTokenAddress);
    console.log("Set ENERGY token address for the world");

    world.app__mapCreate(true, 0, 0); // Width and height not used
    console.log("Created map");

    createItems(world);
    console.log("Created items");

    createItemCreations(world);
    console.log("Created item creations");

    createItemProductions(world);
    console.log("Created item productions");

    world.app__playerCreate("TestPlayer");
    uint256 playerId = PlayerIdGenerator.getId();
    console.log("Created test player, playerId:", playerId);
    // Airdrop items to the test player
    world.app__playerAirdrop(playerId, 1, 100); // 100 PotatoSeeds
    world.app__playerAirdrop(playerId, 2, 50); // 50 CottonSeeds
    world.app__playerAirdrop(playerId, 200, 200); // 200 NormalLogs
    world.app__playerAirdrop(playerId, 301, 150); // 150 CopperOre
    world.app__playerAirdrop(playerId, 302, 150); // 150 TinOre
    console.log("Airdropped items to test player");

    // Tests...
    // Call increment on the world via the registered function selector
    //uint32 newValue = IWorld(worldAddress).app__increment();
    //console.log("Increment via IWorld:", newValue);

    vm.stopBroadcast();
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
      3, // skillType (mining)
      301, // itemId (CopperOre)
      1, // requirementsLevel
      1, // baseQuantity
      0, // baseExperience
      3, // baseCreationTime
      1000000000, // energyCost
      100, // successRate
      1 // resourceCost
    );

    // Woodcutting
    world.app__itemCreationCreate(
      2, // skillType (woodcutting)
      200, // itemId (NormalLogs)
      1, // requirementsLevel
      1, // baseQuantity
      0, // baseExperience
      3, // baseCreationTime
      1000000000, // energyCost
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
      0, // skillType (farming)
      102, // itemId (Cottons)
      1, // requirementsLevel
      1, // baseQuantity
      5, // baseExperience
      15, // baseCreationTime
      5000000000, // energyCost
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
      4, // skillType (crafting, assuming 4 is for crafting)
      1000000001, // itemId (Ship)
      1, // requirementsLevel
      1, // baseQuantity
      0, // baseExperience (adjusted to 0 as per the script)
      15, // baseCreationTime (adjusted to 15 seconds as per the script)
      5000000000, // energyCost (adjusted to match the script)
      100, // successRate
      shipMaterialItemIds,
      shipMaterialItemQuantities
    );
  }
}
