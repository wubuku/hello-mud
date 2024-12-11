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
import { Map, MapLocationData, MapLocation, IslandRenewableItem, EnergyToken, ItemCreationData, ItemCreation, ItemProductionData, ItemProduction, PlayerInventoryCount, PlayerInventory } from "../src/codegen/index.sol";

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import { SkillType } from "../src/systems/SkillType.sol";
import { PlayerIdGenerator } from "../src/codegen/index.sol";
import { ItemIdQuantityPair } from "../src/systems/ItemIdQuantityPair.sol";
import { Coordinates } from "../src/systems/Coordinates.sol";
import { PlayerInventoryUpdateUtil } from "../src/utils/PlayerInventoryUpdateUtil.sol";
import { MapUtil } from "../src/utils/MapUtil.sol";

contract PostDeploy is Script {
  //Item ids
  uint32 constant UNUSED_ITEM_ID = 0;
  uint32 constant POTATO_SEEDS_ITEM_ID = 1;
  uint32 constant POTATOES_ITEM_ID = 101;
  uint32 constant COTTON_SEEDS_ITEM_ID = 2;
  uint32 constant COTTONS_ITEM_ID = 102;
  uint32 constant BRONZE_BAR_ITEM_ID = 1001;
  uint32 constant NORMAL_LOGS_ITEM_ID = 200;
  uint32 constant OAK_LOGS_ITEM_ID = 201;
  uint32 constant SHIP_ITEM_ID = 1000000001;
  uint32 constant FLUYT_ITEM_ID = 1000000002;
  uint32 constant COPPER_ORE_ITEM_ID = 301;
  uint32 constant TIN_ORE_ITEM_ID = 302;
  uint32 constant MINION_ITEM_ID = 401;
  uint32 constant SMALL_SAIL_ITEM_ID = 402;
  uint32 constant RESOURCE_TYPE_WOODCUTTING_ITEM_ID = 2000000001;
  uint32 constant RESOURCE_TYPE_FISHING_ITEM_ID = 2000000002;
  uint32 constant RESOURCE_TYPE_MINING_ITEM_ID = 2000000003;

  //Quantity weights

  uint32 resourceWoodCuttingQuantity = 100;
  uint32 resourceMinningQuantity = 200;
  uint32 resoucePotatoSeedsQuantity = 300;
  uint32 resouceCottonSeedsQuantity = 400;

  // Island resouces renewal information
  uint32 constant ISLAND_RESOURCES_RENEWAL_QUANTITY = 1000;
  uint32 islandResourceRenewalQuantity = 1000;
  uint32 constant ISLAND_RESOURCES_RENEWAL_TIME = 1;
  uint64 islandResourceRenewalTime = 1; //Only 1S // 24 * 60 * 60; //One day=24hours * 60 mins * 60 second

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

    bool islandClaimWhitelistEnabled = false; // NOTE: Set to true to enable the island claim whitelist!s
    uint32[] memory islandRenewableItemIds = new uint32[](4); //todo: add renewable item ids
    islandRenewableItemIds[0] = RESOURCE_TYPE_WOODCUTTING_ITEM_ID;
    islandRenewableItemIds[1] = RESOURCE_TYPE_MINING_ITEM_ID;
    islandRenewableItemIds[2] = POTATO_SEEDS_ITEM_ID;
    islandRenewableItemIds[3] = COTTON_SEEDS_ITEM_ID;
    world.app__mapCreate(
      true,
      islandClaimWhitelistEnabled,
      ISLAND_RESOURCES_RENEWAL_QUANTITY,
      ISLAND_RESOURCES_RENEWAL_TIME,
      islandRenewableItemIds
    );
    console.log("Created map, islandClaimWhitelistEnabled:", islandClaimWhitelistEnabled);

    // Island Resource and The weight of the quantity
    ItemIdQuantityPair[] memory islandResources = createIslandResources();
    for (uint i = 0; i < islandResources.length; i++) {
      world.app__islandRenewableItemCreate(islandResources[i].itemId, islandResources[i].quantity);
    }

    uint32[] memory islandRenewableItemIdsFromMap = Map.getIslandRenewableItemIds();
    for (uint i = 0; i < islandRenewableItemIdsFromMap.length; i++) {
      console.log("Item Id:%d", islandRenewableItemIdsFromMap[i]);
      uint32 quantityWeight = IslandRenewableItem.getQuantityWeight(islandRenewableItemIdsFromMap[i]);
      console.log("Quantity weight:%d", quantityWeight);
      if (islandRenewableItemIdsFromMap[i] == RESOURCE_TYPE_WOODCUTTING_ITEM_ID) {
        if (quantityWeight != resourceWoodCuttingQuantity) {
          console.log("Resouce Wood Cutting quantity weight should be:%d", resourceWoodCuttingQuantity);
        }
      } else if (islandRenewableItemIdsFromMap[i] == RESOURCE_TYPE_MINING_ITEM_ID) {
        if (quantityWeight != resourceMinningQuantity) {
          console.log("Resouce Mining quantity weight should be:%d", resourceMinningQuantity);
        }
      } else if (islandRenewableItemIdsFromMap[i] == POTATO_SEEDS_ITEM_ID) {
        if (quantityWeight != resoucePotatoSeedsQuantity) {
          console.log("Resouce Potato Seeds quantity weight should be:%d", resoucePotatoSeedsQuantity);
        }
      } else if (islandRenewableItemIdsFromMap[i] == COTTON_SEEDS_ITEM_ID) {
        if (quantityWeight != resouceCottonSeedsQuantity) {
          console.log("Resouce Cotton Seeds quantity weight should be:%d", resouceCottonSeedsQuantity);
        }
      } else {
        console.log("Unrecognized Item id:%d", islandRenewableItemIdsFromMap[i]);
      }
    }

    world.app__islandClaimWhitelistAdd(deployerAddress);
    console.log("Added deployer address to the island claim whitelist");

    uint32 firstIslandX = 2147483647;
    uint32 firstIslandY = 2147483647;
    addIsland(world, firstIslandX, firstIslandY);

    // uint32 secondIslandX = 2147483647 + 10000;
    // uint32 secondIslandY = 2147483647 + 10000;
    // addIsland(world, secondIslandX, secondIslandY);

    // // Test add multi islands
    // uint32 resourceSubtotal = 600;
    // uint islandCount = 5;
    // uint32[] memory multiCoordinatesX = new uint32[](islandCount);
    // uint32[] memory multiCoordinatesY = new uint32[](islandCount);
    // for (uint i = 0; i < islandCount; i++) {
    //   multiCoordinatesX[i] = secondIslandX + 10000 * uint32(i + 1);
    //   multiCoordinatesY[i] = secondIslandY + 10000 * uint32(i + 1);
    // }
    // addMultiIslands(world, multiCoordinatesX, multiCoordinatesY, resourceSubtotal);

    // Create items
    createItems(world);
    console.log("Created items");
    //Create Item Creations(Mining & Cutting)
    createItemCreations(world);
    console.log("Created item creations");
    //Create Item Productions(Planting Cottons & Crafting Ship)
    createItemProductions(world);
    console.log("Created item productions");

    // Create experience table
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

    MapLocationData memory location = MapLocation.get(firstIslandX, firstIslandY);
    console.log("Before claimed,gather at:%d", location.gatheredAt);
    //Player claim island
    world.app__playerClaimIsland(playerId, firstIslandX, firstIslandY);
    console.log("An island claimed by test player");
    location = MapLocation.get(firstIslandX, firstIslandY);
    console.log("After claimed,gather at:%d", location.gatheredAt);

    uint256 startTime = block.timestamp;

    //Before gather island resources
    console.log("Before gather resources-------------------------------------");
    uint64 playerInventoryCount1 = PlayerInventoryCount.get(playerId); // same as getCount(playerId)
    console.log("Player's Inventory count1:%d(By get(playerId))", playerInventoryCount1);
    for (uint64 i = 0; i < playerInventoryCount1; i++) {
      uint32 itemId = PlayerInventory.getInventoryItemId(playerId, i);
      uint32 quantity = PlayerInventory.getInventoryQuantity(playerId, i);
      console.log("Item Id:%d,Quantity:%d", itemId, quantity);
    }
    //将上次收集资源的时间减少 ISLAND_RESOURCES_RENEWAL_TIME 秒，以便可以测试 app__playerGatherIslandResources
    MapLocation.setGatheredAt(firstIslandX, firstIslandY, location.gatheredAt - ISLAND_RESOURCES_RENEWAL_TIME);
    location = MapLocation.get(firstIslandX, firstIslandY);
    console.log("After change GatherAt,gather at to->:%d", location.gatheredAt);

    uint64 islandResourceRenewalTimeFromMap = Map.getIslandResourceRenewalTime();
    console.log("islandResourceRenewalTime=%d", islandResourceRenewalTimeFromMap);
    uint32 islandResourceRenewalQuantityFromMap = Map.getIslandResourceRenewalQuantity();
    console.log("islandResourceRenewalQuantity=%d", islandResourceRenewalQuantityFromMap);
    console.log("current time-gatheredAt:%d", startTime - location.gatheredAt);
    if (startTime - location.gatheredAt < islandResourceRenewalTimeFromMap) {
      console.log("startTime - location.gatheredAt < islandResourceRenewalTimeFromMap!!!!");
      return;
    }
    world.app__playerGatherIslandResources(playerId);
    console.log("After gather resources-------------------------------------");
    playerInventoryCount1 = PlayerInventoryCount.get(playerId);
    console.log("Player's Inventory count1:%d(By get(playerId))", playerInventoryCount1);
    for (uint64 i = 0; i < playerInventoryCount1; i++) {
      uint32 itemId = PlayerInventory.getInventoryItemId(playerId, i);
      uint32 quantity = PlayerInventory.getInventoryQuantity(playerId, i);
      console.log("Item Id:%d,Quantity:%d", itemId, quantity);
    }

    // // Airdrop items to the test player
    // world.app__playerAirdrop(playerId, 1, 200); // 200 PotatoSeeds
    // world.app__playerAirdrop(playerId, 2, 200); // 200 CottonSeeds
    // world.app__playerAirdrop(playerId, 200, 200); // 200 NormalLogs
    // world.app__playerAirdrop(playerId, 301, 200); // 200 CopperOre
    // world.app__playerAirdrop(playerId, 302, 200); // 200 TinOre
    // world.app__playerAirdrop(playerId, 102, 200); // 200 Cottons
    // console.log("Airdropped items to test player");

    // world.app__uniApiStartCreation(uint8(SkillType.MINING), playerId, 0, 301, 1);
    // console.log("Started mining of 1 CopperOre");

    // uint32 cottonSeedsItemId = 2;
    // uint32 cottonItemId = 102;
    // uint32 beforeFarmingCottonSeedsQuantity = PlayerInventoryUpdateUtil.getItemQuantity(playerId, cottonSeedsItemId);
    // console.log("Before farming,cotton seeds quantity:", beforeFarmingCottonSeedsQuantity);
    // uint8 skillProcessSequenceNumber = 1;

    // uint32 batchSize = 100;

    // ItemProductionData memory itemProductionData = ItemProduction.get(SkillType.FARMING, cottonItemId);
    // console.log("itemProductionData.energyCost:", itemProductionData.energyCost);
    // uint256 energyCost = uint256(itemProductionData.energyCost) * batchSize;
    // console.log("itemProductionData.energyCost * batchSize=", energyCost);

    // world.app__uniApiStartProduction(SkillType.FARMING, playerId, skillProcessSequenceNumber, cottonItemId, batchSize); // Cotton
    // console.log("Started farming of %d Cotton", batchSize);
    // uint32 afterFarmingCottonSeedsQuantity = PlayerInventoryUpdateUtil.getItemQuantity(playerId, cottonSeedsItemId);
    // console.log("After farming,cotton seeds quantity:", afterFarmingCottonSeedsQuantity);
    // if (beforeFarmingCottonSeedsQuantity - afterFarmingCottonSeedsQuantity != batchSize) {
    //   console.log("After farming,cotton seeds quantity error");
    // }

    // ItemIdQuantityPair[] memory shipProductionMaterials = new ItemIdQuantityPair[](3);
    // shipProductionMaterials[0] = ItemIdQuantityPair(102, 5); // Cotton
    // shipProductionMaterials[1] = ItemIdQuantityPair(200, 5); // NormalLogs
    // shipProductionMaterials[2] = ItemIdQuantityPair(301, 5); // CopperOre
    // world.app__uniApiStartShipProduction(uint8(SkillType.CRAFTING), playerId, 0, 1000000001, shipProductionMaterials);
    // console.log("Started ship production");

    // uint256 environmentRosterPlayerId = type(uint256).max;
    // uint32 environmentRosterSequenceNumber = 1;
    // uint32 environmentRosterCoordinatesX = firstIslandX + 300;
    // uint32 environmentRosterCoordinatesY = firstIslandY + 300;
    // uint32 environmentRosterShipResourceQuantity = 15;
    // uint32 environmentRosterShipBaseResourceQuantity = 3;
    // uint32 environmentRosterBaseExperience = 10;

    // world.app__rosterCreateEnvironmentRoster(
    //   environmentRosterPlayerId,
    //   environmentRosterSequenceNumber,
    //   environmentRosterCoordinatesX,
    //   environmentRosterCoordinatesY,
    //   environmentRosterShipResourceQuantity,
    //   environmentRosterShipBaseResourceQuantity,
    //   environmentRosterBaseExperience
    // );
    // console.log("Created an environment roster");

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

  function createIslandResources() internal view returns (ItemIdQuantityPair[] memory) {
    ItemIdQuantityPair[] memory resources = new ItemIdQuantityPair[](4);
    resources[0] = ItemIdQuantityPair(COTTON_SEEDS_ITEM_ID, resouceCottonSeedsQuantity); // CottonSeeds
    resources[1] = ItemIdQuantityPair(RESOURCE_TYPE_WOODCUTTING_ITEM_ID, resourceWoodCuttingQuantity); // ResourceTypeWoodcutting
    resources[2] = ItemIdQuantityPair(RESOURCE_TYPE_MINING_ITEM_ID, resourceMinningQuantity); // ResourceTypeMining
    resources[3] = ItemIdQuantityPair(POTATO_SEEDS_ITEM_ID, resoucePotatoSeedsQuantity); // PotatoSeeds
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
    world.app__itemCreate(1, false, 5, "PotatoSeeds");
    world.app__itemCreate(101, true, 1, "Potatoes");
    world.app__itemCreate(2, false, 5, "CottonSeeds");
    world.app__itemCreate(102, true, 1, "Cottons");
    world.app__itemCreate(1001, true, 1, "BronzeBar");
    world.app__itemCreate(200, true, 1, "NormalLogs");
    world.app__itemCreate(201, true, 1, "OakLogs");
    world.app__itemCreate(1000000001, true, 1, "Ship");
    world.app__itemCreate(1000000002, true, 1, "Fluyt");
    world.app__itemCreate(301, true, 1, "CopperOre");
    world.app__itemCreate(302, true, 1, "TinOre");
    world.app__itemCreate(401, true, 1, "Minion");
    world.app__itemCreate(402, true, 1, "SmallSail");
    world.app__itemCreate(2000000001, false, 1, "ResourceTypeWoodcutting");
    world.app__itemCreate(2000000002, false, 1, "ResourceTypeFishing");
    world.app__itemCreate(2000000003, false, 1, "ResourceTypeMining");
  }

  function createItemCreations(IWorld world) internal {
    // Mining Cooper Ore
    world.app__itemCreationCreate(
      uint8(SkillType.MINING), // skillType (mining)
      COPPER_ORE_ITEM_ID, // itemId (CopperOre)
      1, // requirementsLevel
      1, // baseQuantity
      0, // baseExperience
      3, // baseCreationTime
      1 * 10 ** 18, // energyCost
      100, // successRate
      1 // resourceCost
    );

    // Mining Tin Ore
    //Let's switch "bronze" to "tin". Tin is a new resource that belongs to Mining.
    //If a player chooses to mine "Tin," the Mine resources on the island will be reduced similarly to copper.
    //However, the energy cost of mining "Tin" will be 1.5 for each unit mined, and the mining time will be 5 seconds per unit.
    world.app__itemCreationCreate(
      uint8(SkillType.MINING), // skillType (mining)
      TIN_ORE_ITEM_ID, // itemId (Tin ore)
      1, // requirementsLevel
      1, // baseQuantity
      0, // baseExperience
      5, // baseCreationTime
      1.5 * 10 ** 18, // energyCost
      100, // successRate
      1 // resourceCost
    );

    // Woodcutting NormalLogs
    world.app__itemCreationCreate(
      uint8(SkillType.WOODCUTTING), // skillType (woodcutting)
      NORMAL_LOGS_ITEM_ID, // itemId (NormalLogs)
      1, // requirementsLevel
      1, // baseQuantity
      0, // baseExperience
      3, // baseCreationTime
      1 * 10 ** 18, // energyCost
      100, // successRate
      1 // resourceCost
    );

    // Woodcutting Oaklogs
    world.app__itemCreationCreate(
      uint8(SkillType.WOODCUTTING), // skillType (woodcutting)
      OAK_LOGS_ITEM_ID, // itemId (Oaklogs)
      1, // requirementsLevel
      1, // baseQuantity
      0, // baseExperience
      3, // baseCreationTime
      1 * 10 ** 18, // energyCost
      100, // successRate
      1 // resourceCost
    );
  }

  function createItemProductions(IWorld world) internal {
    // Farming (Cotton Seeds to Cotton)
    uint32[] memory cottonMaterialItemIds = new uint32[](1);
    cottonMaterialItemIds[0] = COTTON_SEEDS_ITEM_ID; // ItemCottonSeeds.ItemId

    uint32[] memory cottonMaterialItemQuantities = new uint32[](1);
    cottonMaterialItemQuantities[0] = 1;

    world.app__itemProductionCreate(
      uint8(SkillType.FARMING), // skillType (farming)
      COTTONS_ITEM_ID, // itemId (Cottons)
      1, // requirementsLevel
      5, // baseQuantity
      0, // baseExperience
      15, // baseCreationTime
      5 * 10 ** 18, // energyCost
      100, // successRate
      cottonMaterialItemIds,
      cottonMaterialItemQuantities
    );

    // Farming (Potato Seeds to Potatoes)
    uint32[] memory potatoMaterialItemIds = new uint32[](1);
    potatoMaterialItemIds[0] = POTATO_SEEDS_ITEM_ID; // ItemPotatoSeeds.ItemId

    uint32[] memory potatoMaterialItemQuantities = new uint32[](1);
    potatoMaterialItemQuantities[0] = 1;

    world.app__itemProductionCreate(
      uint8(SkillType.FARMING), // skillType (farming)
      POTATOES_ITEM_ID, // itemId (Potatoes)
      1, // requirementsLevel
      5, // baseQuantity
      0, // baseExperience
      15, // baseCreationTime
      5 * 10 ** 18, // energyCost
      100, // successRate
      potatoMaterialItemIds,
      potatoMaterialItemQuantities
    );

    // Ship crafting
    uint32[] memory shipMaterialItemIds = new uint32[](3);
    shipMaterialItemIds[0] = COTTONS_ITEM_ID; // Cottons
    shipMaterialItemIds[1] = NORMAL_LOGS_ITEM_ID; // NormalLogs
    shipMaterialItemIds[2] = COPPER_ORE_ITEM_ID; // CopperOre

    uint32[] memory shipMaterialItemQuantities = new uint32[](3);
    shipMaterialItemQuantities[0] = 3; // 3 Cottons
    shipMaterialItemQuantities[1] = 3; // 3 NormalLogs
    shipMaterialItemQuantities[2] = 3; // 3 CopperOre

    world.app__itemProductionCreate(
      uint8(SkillType.CRAFTING),
      SHIP_ITEM_ID, // itemId (Ship)
      1, // requirementsLevel
      1, // baseQuantity
      0, // baseExperience (adjusted to 0 as per the script)
      15, // baseCreationTime
      5 * 10 ** 18, // energyCost (adjusted to match the script)
      100, // successRate
      shipMaterialItemIds,
      shipMaterialItemQuantities
    );

    // Fluyt crafting
    uint32[] memory fluytMaterialItemIds = new uint32[](3);
    fluytMaterialItemIds[0] = POTATOES_ITEM_ID; // Potatoes
    fluytMaterialItemIds[1] = OAK_LOGS_ITEM_ID; // OkaLogs
    fluytMaterialItemIds[2] = TIN_ORE_ITEM_ID; // TinOre

    uint32[] memory fluytMaterialItemQuantities = new uint32[](3);
    fluytMaterialItemQuantities[0] = 3; // 3 Potatoes
    fluytMaterialItemQuantities[1] = 3; // 3 OkaLogs
    fluytMaterialItemQuantities[2] = 3; // 3 TinOre

    world.app__itemProductionCreate(
      uint8(SkillType.CRAFTING),
      FLUYT_ITEM_ID, // itemId (Fluyt)
      1, // requirementsLevel
      1, // baseQuantity
      0, // baseExperience (adjusted to 0 as per the script)
      15, // baseCreationTime
      5 * 10 ** 18, // energyCost (adjusted to match the script)
      100, // successRate
      fluytMaterialItemIds,
      fluytMaterialItemQuantities
    );
  }
}
