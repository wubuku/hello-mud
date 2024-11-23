// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";

import { IWorld } from "../src/codegen/world/IWorld.sol";
import { ItemIdQuantityPair } from "../src/systems/ItemIdQuantityPair.sol";

// We need to create the ResourceID for the System we are calling
import { ResourceId, WorldResourceIdLib, WorldResourceIdInstance } from "@latticexyz/world/src/WorldResourceId.sol";
import { RESOURCE_SYSTEM } from "@latticexyz/world/src/worldResourceTypes.sol";

import { SystemCallData } from "@latticexyz/world/src/modules/init/types.sol";

//批量添加岛屿（使用Batchcall一个个添加） forge script BatchAddSingleIsland.s.sol:BatchCall --sig "run(address)" 0x63381030dda22c888f2548436c73146ef835ab9e --broadcast --rpc-url https://odyssey.storyrpc.io/
contract BatchCall is Script {
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

  uint32 resourceWoodCuttingQuantity = 200;
  uint32 resourceMinningQuantity = 200;
  uint32 resoucePotatoSeedsQuantity = 200;
  uint32 resouceCottonSeedsQuantity = 200;
  function run(address worldAddress) external {
    StoreSwitch.setStoreAddress(worldAddress);
    //IWorld world = IWorld(worldAddress);

    // Load the private key from the `PRIVATE_KEY` environment variable (in .env)
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

    // Start broadcasting transactions from the deployer account
    vm.startBroadcast(deployerPrivateKey);

    ResourceId systemId = WorldResourceIdLib.encode({
      typeId: RESOURCE_SYSTEM,
      namespace: "app",
      name: "MapSystem" //mapAddIsland方法所在的合约的名称的前16位
    });
    //每次修改以下这两个数组即可，coordinatesX：岛屿 X 坐标数组，coordinatesY：岛屿 Y 坐标数组
    uint32[2] memory coordinatesX = [uint32(0), uint32(50)];
    uint32[2] memory coordinatesY = [uint32(0), uint32(50)];

    ItemIdQuantityPair[] memory islandResources = createIslandResources();
    //logIslandResources(islandResources);

    SystemCallData[] memory calls = new SystemCallData[](coordinatesX.length);
    for (uint i = 0; i < coordinatesX.length; i++) {
      calls[i].systemId = systemId;
      calls[i].callData = abi.encodeWithSignature(
        "mapAddIsland(uint32,uint32,(uint32,uint32)[])",
        coordinatesX[i],
        coordinatesY[i],
        islandResources
      );
    }
    bytes[] memory returnData = IWorld(worldAddress).batchCall(calls);
    for (uint i = 0; i < returnData.length; i++) {
      console.log("The return value is:");
      console.logBytes(returnData[i]);
    }
    //world.app__islandClaimWhitelistUpdate(accountAddress, allowed);
    vm.stopBroadcast();
  }

  function createIslandResources() internal view returns (ItemIdQuantityPair[] memory) {
    ItemIdQuantityPair[] memory resources = new ItemIdQuantityPair[](4);
    resources[0] = ItemIdQuantityPair(COTTON_SEEDS_ITEM_ID, resouceCottonSeedsQuantity); // CottonSeeds
    resources[1] = ItemIdQuantityPair(RESOURCE_TYPE_WOODCUTTING_ITEM_ID, resourceWoodCuttingQuantity); // ResourceTypeWoodcutting
    resources[2] = ItemIdQuantityPair(RESOURCE_TYPE_MINING_ITEM_ID, resourceMinningQuantity); // ResourceTypeMining
    resources[3] = ItemIdQuantityPair(POTATO_SEEDS_ITEM_ID, resoucePotatoSeedsQuantity); // PotatoSeeds
    return resources;
  }

  function logIslandResources(ItemIdQuantityPair[] memory resources) internal view {
    console.log("With the following resources:");
    for (uint i = 0; i < resources.length; i++) {
      console.log("    ItemId: %d, Quantity: %d", resources[i].itemId, resources[i].quantity);
    }
  }
}
