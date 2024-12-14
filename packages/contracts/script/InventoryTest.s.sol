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
import { PlayerData, AccountPlayer, Player, PlayerIdGenerator, ShipIdGenerator, ShipBattleIdGenerator, RosterData, Roster, ShipInventory, Ship, ShipData, MapLocationData, MapLocation, Map, MapData } from "../src/codegen/index.sol";
import { ItemIdQuantityPair } from "../src/systems/ItemIdQuantityPair.sol";
import { RosterUtil } from "../src/utils/RosterUtil.sol";

contract CreatePlayerTest is Script {
  //
  // forge script script/CreatePlayerTest.s.sol:CreatePlayerTest --sig "run(address)" <WORLD_ADDRESS> --broadcast --rpc-url http://localhost:8545
  //
  function run(address worldAddress) external {
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

    uint256 playerId = AccountPlayer.get(deployerAddress);
    console.log("Player id:%d", playerId);

    IWorld world = IWorld(worldAddress);

    PlayerData memory playerData = Player.get(playerId);

    console.log("Island x:%d,y:%d", playerData.claimedIslandX, playerData.claimedIslandY);

    MapLocationData memory mapLocationData = MapLocation.get(playerData.claimedIslandX, playerData.claimedIslandY);
    if (!mapLocationData.existing) {
      console.log("Map location data is not exist!");
      return;
    }
    uint32[] memory itemIds;
    uint32[] memory quantities;
    if (mapLocationData.resourcesItemIds.length < 1) {
      ItemIdQuantityPair[] memory resources = createIslandResources();
      itemIds = new uint32[](resources.length);
      quantities = new uint32[](resources.length);
      for (uint i = 0; i < resources.length; i++) {
        itemIds[i] = resources[i].itemId;
        quantities[i] = resources[i].quantity;
      }
      world.app__mapAirdrop(playerData.claimedIslandX, playerData.claimedIslandY, itemIds, quantities);
    } else {
      itemIds = mapLocationData.resourcesItemIds;
      quantities = mapLocationData.resourcesQuantities;
    }
    vm.stopBroadcast();
  }

  function createIslandResources() internal pure returns (ItemIdQuantityPair[] memory) {
    ItemIdQuantityPair[] memory resources = new ItemIdQuantityPair[](3);
    resources[0] = ItemIdQuantityPair(2, 200); // CottonSeeds
    resources[1] = ItemIdQuantityPair(2000000001, 200); // ResourceTypeWoodcutting
    resources[2] = ItemIdQuantityPair(2000000003, 200); // ResourceTypeMining
    return resources;
  }
}
