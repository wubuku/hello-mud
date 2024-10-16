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
import { PlayerIdGenerator } from "../src/codegen/index.sol";
import { ItemIdQuantityPair } from "../src/systems/ItemIdQuantityPair.sol";

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

    // ************************************************************************************************
    // Tests...
    // Call increment on the world via the registered function selector
    //uint32 newValue = IWorld(worldAddress).app__increment();
    //console.log("Increment via IWorld:", newValue);

    //function app__articleCreate(address author, string memory title, string memory body) external;
    //function app__articleAddComment(uint64 id, string memory commenter, string memory body) external;
    IWorld(worldAddress).app__articleCreate(deployerAddress, "My first article", "This is the body of my first article");
    console.log("Article created");
    IWorld(worldAddress).app__articleAddComment(1, "TestUser", "This is a test comment");
    console.log("Comment added");
    IWorld(worldAddress).app__articleUpdateComment(1, 1, "TestUser", "This is an updated comment");
    console.log("Comment updated");
    //IWorld(worldAddress).app__articleRemoveComment(1, 1);
    //console.log("Comment removed");
    
    // ************************************************************************************************

    Energy energyToken = new Energy(deployerAddress);
    address energyTokenAddress = address(energyToken);
    console.log("ENERGY Token address:", energyTokenAddress);

    ResourceId skillProcessServiceSystemId = WorldResourceIdLib.encode({
      typeId: RESOURCE_SYSTEM,
      namespace: "app",
      name: "AggregatorServic" // NOTE: Only the first 16 characters are used. Original: "AggregatorServiceSystem"
    });
    (address spSystemAddress, bool spSysPublicAccess) = Systems.get(skillProcessServiceSystemId);
    console.log("AggregatorServiceSystem address:", spSystemAddress);
    console.log("AggregatorServiceSystem publicAccess:", spSysPublicAccess);

    IERC20 energyIErc20 = IERC20(energyTokenAddress);
    energyIErc20.approve(spSystemAddress, 10000 * 10 ** 18);
    console.log("Approved AggregatorServiceSystem to spend ENERGY tokens");

    IWorld world = IWorld(worldAddress);
    world.app__energyTokenCreate(energyTokenAddress);
    console.log("Set ENERGY token address for the world");

    // ------------------ ENERGY faucet test ------------------
    ResourceId energyDropSystemId = WorldResourceIdLib.encode({
      typeId: RESOURCE_SYSTEM,
      namespace: "app",
      name: "EnergyDropSystem"
    });
    (address energyDropSystemAddress, bool energyDropSysPublicAccess) = Systems.get(energyDropSystemId);
    console.log("EnergyDropSystem address:", energyDropSystemAddress);
    console.log("EnergyDropSystem publicAccess:", energyDropSysPublicAccess);
    // Replenish the faucet with some ENERGY tokens
    energyIErc20.transfer(energyDropSystemAddress, 10000 * 10 ** 18);
    console.log("Sent 10000 ENERGY tokens to the EnergyDropSystem");

    world.app__energyDropRequest(deployerAddress);
    console.log("Requested energy drop");
    // -------------------------------------------------------

    world.app__mapCreate(true, 0, 0); // Width and height not used
    console.log("Created map");

    uint32 firstIslandX = 2147483647;
    uint32 firstIslandY = 2147483647;
    addInitialIsland(world, firstIslandX, firstIslandY);

    uint32 secondIslandX = 2147483647 + 10000;
    uint32 secondIslandY = 2147483647 + 10000;
    addInitialIsland(world, secondIslandX, secondIslandY);

    createItems(world);
    console.log("Created items");

    createItemCreations(world);
    console.log("Created item creations");

    createItemProductions(world);
    console.log("Created item productions");

    world.app__experienceTableCreate(true);
    console.log("Created experience table");

    // Add levels to experience table
    world.app__experienceTableAddLevel(0, 0, 0);
    world.app__experienceTableAddLevel(1, 0, 0);
    world.app__experienceTableAddLevel(2, 83, 83);
    world.app__experienceTableAddLevel(3, 174, 91);
    console.log("Added levels to experience table");

    world.app__playerCreate("TestPlayer");
    uint256 playerId = PlayerIdGenerator.getId();
    console.log("Created test player, playerId:", playerId);

    // Airdrop items to the test player
    world.app__playerAirdrop(playerId, 1, 100); // 100 PotatoSeeds
    world.app__playerAirdrop(playerId, 2, 50); // 50 CottonSeeds
    world.app__playerAirdrop(playerId, 200, 200); // 200 NormalLogs
    world.app__playerAirdrop(playerId, 301, 150); // 150 CopperOre
    world.app__playerAirdrop(playerId, 302, 150); // 150 TinOre
    world.app__playerAirdrop(playerId, 102, 100); // 100 Cottons
    console.log("Airdropped items to test player");

    world.app__playerClaimIsland(playerId, firstIslandX, firstIslandY);
    console.log("An island claimed by test player");

    world.app__uniApiStartCreation(uint8(SkillType.MINING), playerId, 0, 301, 1);
    console.log("Started mining of 1 CopperOre");

    world.app__skillProcessStartProduction(uint8(SkillType.FARMING), playerId, 0, 102, 1); // Cotton
    console.log("Started farming of 1 Cotton");

    ItemIdQuantityPair[] memory shipProductionMaterials = new ItemIdQuantityPair[](3);
    shipProductionMaterials[0] = ItemIdQuantityPair(102, 5); // Cotton
    shipProductionMaterials[1] = ItemIdQuantityPair(200, 5); // NormalLogs
    shipProductionMaterials[2] = ItemIdQuantityPair(301, 5); // CopperOre
    world.app__uniApiStartShipProduction(uint8(SkillType.CRAFTING), playerId, 0, 1000000001, shipProductionMaterials);
    console.log("Started ship production");

    uint256 environmentRosterPlayerId = type(uint256).max;
    uint32 environmentRosterSequenceNumber = 1;
    uint32 environmentRosterCoordinatesX = firstIslandX + 300;
    uint32 environmentRosterCoordinatesY = firstIslandY + 300;
    uint32 environmentRosterShipResourceQuantity = 15;
    uint32 environmentRosterShipBaseResourceQuantity = 3;
    uint32 environmentRosterBaseExperience = 10;

    world.app__rosterCreateEnvironmentRoster(
      environmentRosterPlayerId,
      environmentRosterSequenceNumber,
      environmentRosterCoordinatesX,
      environmentRosterCoordinatesY,
      environmentRosterShipResourceQuantity,
      environmentRosterShipBaseResourceQuantity,
      environmentRosterBaseExperience
    );
    console.log("Created an environment roster");

    // You need to wait for the creation time to complete...
    // Then execute the ManualSmokeTest script

    vm.stopBroadcast();
  }

  function addInitialIsland(IWorld world, uint32 coordinatesX, uint32 coordinatesY) internal {
    ItemIdQuantityPair[] memory islandResources = createIslandResources();

    console.log("Adding an island to the map at coordinates (%d, %d)", coordinatesX, coordinatesY);
    logIslandResources(islandResources);

    world.app__mapAddIsland(coordinatesX, coordinatesY, islandResources);
    console.log("Island added successfully.");
  }

  function createIslandResources() internal pure returns (ItemIdQuantityPair[] memory) {
    ItemIdQuantityPair[] memory resources = new ItemIdQuantityPair[](3);
    resources[0] = ItemIdQuantityPair(2, 200); // CottonSeeds
    resources[1] = ItemIdQuantityPair(2000000001, 100); // ResourceTypeWoodcutting
    resources[2] = ItemIdQuantityPair(2000000003, 200); // ResourceTypeMining
    return resources;
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
      1, // baseCreationTime // Let's speed up the game for testing purposes
      1000000000, // energyCost
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
      1, // baseCreationTime
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
      uint8(SkillType.FARMING), // skillType (farming)
      102, // itemId (Cottons)
      1, // requirementsLevel
      1, // baseQuantity
      5, // baseExperience
      1, // baseCreationTime
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
      uint8(SkillType.CRAFTING),
      1000000001, // itemId (Ship)
      1, // requirementsLevel
      1, // baseQuantity
      0, // baseExperience (adjusted to 0 as per the script)
      1, // baseCreationTime
      5000000000, // energyCost (adjusted to match the script)
      100, // successRate
      shipMaterialItemIds,
      shipMaterialItemQuantities
    );
  }
}
