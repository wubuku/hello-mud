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
      uint32(2147579647),
      uint32(2147578247),
      uint32(2147578447),
      uint32(2147579847),
      uint32(2147580447),
      uint32(2147578547),
      uint32(2147576947),
      uint32(2147578047),
      uint32(2147580447),
      uint32(2147590647),
      uint32(2147589747),
      uint32(2147588047),
      uint32(2147589047),
      uint32(2147586847),
      uint32(2147588247),
      uint32(2147588147),
      uint32(2147588347),
      uint32(2147589147),
      uint32(2147600447),
      uint32(2147596647),
      uint32(2147599847),
      uint32(2147599247),
      uint32(2147598547),
      uint32(2147596947),
      uint32(2147599247),
      uint32(2147600347),
      uint32(2147598647),
      uint32(2147609447),
      uint32(2147607847),
      uint32(2147608647),
      uint32(2147609147),
      uint32(2147608047),
      uint32(2147609947),
      uint32(2147609547),
      uint32(2147610447),
      uint32(2147608447),
      uint32(2147619547),
      uint32(2147619047),
      uint32(2147618247),
      uint32(2147616747),
      uint32(2147616747),
      uint32(2147618947),
      uint32(2147619847),
      uint32(2147619747),
      uint32(2147619547),
      uint32(2147629447),
      uint32(2147628847),
      uint32(2147628047),
      uint32(2147628447),
      uint32(2147629747),
      uint32(2147630347),
      uint32(2147627847),
      uint32(2147627447),
      uint32(2147628847),
      uint32(2147636847),
      uint32(2147640547),
      uint32(2147638547),
      uint32(2147638447),
      uint32(2147638747),
      uint32(2147637547),
      uint32(2147639847),
      uint32(2147637347),
      uint32(2147636647),
      uint32(2147649147),
      uint32(2147649347),
      uint32(2147648147),
      uint32(2147648847),
      uint32(2147648247),
      uint32(2147649147),
      uint32(2147649747),
      uint32(2147648847),
      uint32(2147650447),
      uint32(2147658147),
      uint32(2147657747),
      uint32(2147658947),
      uint32(2147657447),
      uint32(2147657947),
      uint32(2147657947),
      uint32(2147658047),
      uint32(2147656747),
      uint32(2147657347)
    ];

    uint32[81] memory coordinatesY = [
      uint32(2147580047),
      uint32(2147589647),
      uint32(2147599747),
      uint32(2147607547),
      uint32(2147619947),
      uint32(2147630147),
      uint32(2147637247),
      uint32(2147647147),
      uint32(2147657747),
      uint32(2147577447),
      uint32(2147589047),
      uint32(2147597747),
      uint32(2147609647),
      uint32(2147620347),
      uint32(2147629047),
      uint32(2147637947),
      uint32(2147649947),
      uint32(2147658847),
      uint32(2147579047),
      uint32(2147587547),
      uint32(2147599547),
      uint32(2147609647),
      uint32(2147619947),
      uint32(2147627847),
      uint32(2147639847),
      uint32(2147648747),
      uint32(2147660147),
      uint32(2147577247),
      uint32(2147587647),
      uint32(2147600547),
      uint32(2147607447),
      uint32(2147619847),
      uint32(2147627647),
      uint32(2147639747),
      uint32(2147649047),
      uint32(2147656847),
      uint32(2147580647),
      uint32(2147589847),
      uint32(2147598047),
      uint32(2147607247),
      uint32(2147619147),
      uint32(2147628347),
      uint32(2147640447),
      uint32(2147648447),
      uint32(2147658047),
      uint32(2147580247),
      uint32(2147589747),
      uint32(2147599647),
      uint32(2147607547),
      uint32(2147618647),
      uint32(2147628847),
      uint32(2147636947),
      uint32(2147648447),
      uint32(2147659047),
      uint32(2147577347),
      uint32(2147587547),
      uint32(2147598447),
      uint32(2147607447),
      uint32(2147620047),
      uint32(2147630047),
      uint32(2147638047),
      uint32(2147647247),
      uint32(2147658947),
      uint32(2147576947),
      uint32(2147589347),
      uint32(2147596947),
      uint32(2147606847),
      uint32(2147617547),
      uint32(2147629447),
      uint32(2147638347),
      uint32(2147647347),
      uint32(2147658647),
      uint32(2147579147),
      uint32(2147590147),
      uint32(2147599347),
      uint32(2147607247),
      uint32(2147617447),
      uint32(2147627447),
      uint32(2147637147),
      uint32(2147648447),
      uint32(2147659647)
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
