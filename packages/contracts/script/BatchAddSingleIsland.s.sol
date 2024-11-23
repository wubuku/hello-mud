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
    uint32[81] memory coordinatesX = [
      uint32(2147580247),
      uint32(2147577747),
      uint32(2147577947),
      uint32(2147577147),
      uint32(2147580547),
      uint32(2147579447),
      uint32(2147577447),
      uint32(2147578447),
      uint32(2147578147),
      uint32(2147590447),
      uint32(2147587147),
      uint32(2147588547),
      uint32(2147589347),
      uint32(2147588447),
      uint32(2147589147),
      uint32(2147589347),
      uint32(2147589747),
      uint32(2147588147),
      uint32(2147599247),
      uint32(2147598347),
      uint32(2147598647),
      uint32(2147600147),
      uint32(2147599247),
      uint32(2147598547),
      uint32(2147596847),
      uint32(2147599947),
      uint32(2147598347),
      uint32(2147607147),
      uint32(2147608747),
      uint32(2147607447),
      uint32(2147608047),
      uint32(2147609847),
      uint32(2147609747),
      uint32(2147607047),
      uint32(2147606647),
      uint32(2147609247),
      uint32(2147619147),
      uint32(2147619647),
      uint32(2147619047),
      uint32(2147617147),
      uint32(2147620647),
      uint32(2147620447),
      uint32(2147620547),
      uint32(2147618247),
      uint32(2147617047),
      uint32(2147629747),
      uint32(2147627847),
      uint32(2147627847),
      uint32(2147630147),
      uint32(2147628047),
      uint32(2147626647),
      uint32(2147628847),
      uint32(2147630547),
      uint32(2147627147),
      uint32(2147636847),
      uint32(2147639847),
      uint32(2147637547),
      uint32(2147638247),
      uint32(2147638947),
      uint32(2147639647),
      uint32(2147637947),
      uint32(2147636747),
      uint32(2147638047),
      uint32(2147648647),
      uint32(2147650547),
      uint32(2147646647),
      uint32(2147648247),
      uint32(2147649847),
      uint32(2147648047),
      uint32(2147648847),
      uint32(2147647147),
      uint32(2147646847),
      uint32(2147658047),
      uint32(2147660347),
      uint32(2147657647),
      uint32(2147660347),
      uint32(2147660347),
      uint32(2147659647),
      uint32(2147659047),
      uint32(2147656847),
      uint32(2147660147)
    ];
    uint32[81] memory coordinatesY = [
      uint32(2147397447),
      uint32(2147407647),
      uint32(2147417347),
      uint32(2147430547),
      uint32(2147438947),
      uint32(2147446947),
      uint32(2147460647),
      uint32(2147469147),
      uint32(2147480047),
      uint32(2147398847),
      uint32(2147408547),
      uint32(2147417247),
      uint32(2147430547),
      uint32(2147436647),
      uint32(2147449047),
      uint32(2147460347),
      uint32(2147466747),
      uint32(2147478947),
      uint32(2147397847),
      uint32(2147407947),
      uint32(2147420447),
      uint32(2147429647),
      uint32(2147439347),
      uint32(2147449747),
      uint32(2147460447),
      uint32(2147467847),
      uint32(2147478947),
      uint32(2147397347),
      uint32(2147410147),
      uint32(2147419447),
      uint32(2147429847),
      uint32(2147437247),
      uint32(2147447447),
      uint32(2147458047),
      uint32(2147469347),
      uint32(2147477547),
      uint32(2147398047),
      uint32(2147407547),
      uint32(2147420147),
      uint32(2147430547),
      uint32(2147438547),
      uint32(2147447947),
      uint32(2147460547),
      uint32(2147468347),
      uint32(2147476747),
      uint32(2147398647),
      uint32(2147409747),
      uint32(2147419347),
      uint32(2147427947),
      uint32(2147440047),
      uint32(2147448147),
      uint32(2147457547),
      uint32(2147470647),
      uint32(2147479747),
      uint32(2147396847),
      uint32(2147407447),
      uint32(2147417147),
      uint32(2147429247),
      uint32(2147439247),
      uint32(2147448747),
      uint32(2147460147),
      uint32(2147467147),
      uint32(2147479047),
      uint32(2147398547),
      uint32(2147406647),
      uint32(2147417947),
      uint32(2147427447),
      uint32(2147439247),
      uint32(2147448647),
      uint32(2147459747),
      uint32(2147466647),
      uint32(2147477647),
      uint32(2147397247),
      uint32(2147410247),
      uint32(2147416647),
      uint32(2147428547),
      uint32(2147439147),
      uint32(2147448247),
      uint32(2147458047),
      uint32(2147470147),
      uint32(2147479447)
    ];

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
