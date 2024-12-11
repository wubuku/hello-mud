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

//批量添加岛屿（使用Batchcall一个个添加） forge script BatchAirDropToIslands.s.sol:BatchCall --sig "run(address)" 0x63381030dda22c888f2548436c73146ef835ab9e --broadcast --rpc-url https://odyssey.storyrpc.io/
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
      uint32(2147488947),
      uint32(2147489647),
      uint32(2147487747),
      uint32(2147487447),
      uint32(2147488747),
      uint32(2147489347),
      uint32(2147488847),
      uint32(2147490647),
      uint32(2147488547),
      uint32(2147498147),
      uint32(2147498447),
      uint32(2147497947),
      uint32(2147500547),
      uint32(2147497347),
      uint32(2147496647),
      uint32(2147496847),
      uint32(2147500247),
      uint32(2147498347),
      uint32(2147509347),
      uint32(2147506647),
      uint32(2147510247),
      uint32(2147509847),
      uint32(2147509247),
      uint32(2147509747),
      uint32(2147509247),
      uint32(2147507947),
      uint32(2147506647),
      uint32(2147518347),
      uint32(2147519047),
      uint32(2147518947),
      uint32(2147519147),
      uint32(2147520447),
      uint32(2147520547),
      uint32(2147517647),
      uint32(2147520247),
      uint32(2147519147),
      uint32(2147530347),
      uint32(2147528847),
      uint32(2147529347),
      uint32(2147526847),
      uint32(2147527047),
      uint32(2147529947),
      uint32(2147530047),
      uint32(2147529447),
      uint32(2147527847),
      uint32(2147538247),
      uint32(2147536647),
      uint32(2147539847),
      uint32(2147537647),
      uint32(2147538047),
      uint32(2147539247),
      uint32(2147537347),
      uint32(2147537647),
      uint32(2147537247),
      uint32(2147548647),
      uint32(2147547447),
      uint32(2147548147),
      uint32(2147548547),
      uint32(2147546647),
      uint32(2147547847),
      uint32(2147547047),
      uint32(2147549747),
      uint32(2147548647),
      uint32(2147558847),
      uint32(2147557047),
      uint32(2147558447),
      uint32(2147559847),
      uint32(2147558247),
      uint32(2147559747),
      uint32(2147560447),
      uint32(2147559447),
      uint32(2147560247),
      uint32(2147566847),
      uint32(2147567447),
      uint32(2147566847),
      uint32(2147570347),
      uint32(2147568447),
      uint32(2147567747),
      uint32(2147568047),
      uint32(2147567447),
      uint32(2147567447)
    ];

    uint32[81] memory coordinatesY = [
      uint32(2147577047),
      uint32(2147587047),
      uint32(2147596747),
      uint32(2147609447),
      uint32(2147618247),
      uint32(2147628447),
      uint32(2147638447),
      uint32(2147648447),
      uint32(2147657347),
      uint32(2147579447),
      uint32(2147589747),
      uint32(2147598047),
      uint32(2147606747),
      uint32(2147620647),
      uint32(2147628847),
      uint32(2147638147),
      uint32(2147649747),
      uint32(2147658947),
      uint32(2147580347),
      uint32(2147590347),
      uint32(2147599447),
      uint32(2147607747),
      uint32(2147618347),
      uint32(2147630147),
      uint32(2147636747),
      uint32(2147649047),
      uint32(2147659947),
      uint32(2147577247),
      uint32(2147589447),
      uint32(2147598647),
      uint32(2147608047),
      uint32(2147618947),
      uint32(2147628347),
      uint32(2147639147),
      uint32(2147648547),
      uint32(2147660047),
      uint32(2147577547),
      uint32(2147588747),
      uint32(2147598747),
      uint32(2147607447),
      uint32(2147617047),
      uint32(2147630347),
      uint32(2147638147),
      uint32(2147649547),
      uint32(2147660547),
      uint32(2147580247),
      uint32(2147588647),
      uint32(2147596647),
      uint32(2147609847),
      uint32(2147618747),
      uint32(2147628447),
      uint32(2147639347),
      uint32(2147648747),
      uint32(2147659447),
      uint32(2147579247),
      uint32(2147586647),
      uint32(2147597047),
      uint32(2147607547),
      uint32(2147617247),
      uint32(2147629247),
      uint32(2147637847),
      uint32(2147649847),
      uint32(2147657447),
      uint32(2147578047),
      uint32(2147588447),
      uint32(2147599647),
      uint32(2147610447),
      uint32(2147619747),
      uint32(2147629347),
      uint32(2147639947),
      uint32(2147647247),
      uint32(2147658847),
      uint32(2147580647),
      uint32(2147589247),
      uint32(2147597847),
      uint32(2147609847),
      uint32(2147620247),
      uint32(2147628447),
      uint32(2147640047),
      uint32(2147646647),
      uint32(2147657147)
    ];

    ItemIdQuantityPair[] memory toAirDropResoures = createIslandResources();
    uint32[] memory resourcesItemIds = new uint32[](toAirDropResoures.length);
    uint32[] memory resourcesQuantities = new uint32[](toAirDropResoures.length);
    for (uint i = 0; i < toAirDropResoures.length; i++) {
      resourcesItemIds[i] = toAirDropResoures[i].itemId;
      resourcesQuantities[i] = toAirDropResoures[i].quantity;
    }

    SystemCallData[] memory calls = new SystemCallData[](coordinatesX.length);
    for (uint i = 0; i < coordinatesX.length; i++) {
      calls[i].systemId = systemId;
      calls[i].callData = abi.encodeWithSignature(
        "mapAirdrop(uint32,uint32,uint32[],uint32[])",
        coordinatesX[i],
        coordinatesY[i],
        toAirDropResoures
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
    ItemIdQuantityPair[] memory resources = new ItemIdQuantityPair[](3);
    resources[0] = ItemIdQuantityPair(COTTON_SEEDS_ITEM_ID, resouceCottonSeedsQuantity); // CottonSeeds
    resources[1] = ItemIdQuantityPair(RESOURCE_TYPE_WOODCUTTING_ITEM_ID, resourceWoodCuttingQuantity); // ResourceTypeWoodcutting
    resources[2] = ItemIdQuantityPair(RESOURCE_TYPE_MINING_ITEM_ID, resourceMinningQuantity); // ResourceTypeMining
    //resources[3] = ItemIdQuantityPair(POTATO_SEEDS_ITEM_ID, resoucePotatoSeedsQuantity); // PotatoSeeds
    return resources;
  }

  function logIslandResources(ItemIdQuantityPair[] memory resources) internal view {
    console.log("With the following resources:");
    for (uint i = 0; i < resources.length; i++) {
      console.log("    ItemId: %d, Quantity: %d", resources[i].itemId, resources[i].quantity);
    }
  }
}
