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
import { ShipInventoryData, ShipInventoryCount, PlayerData, AccountPlayer, Player, PlayerIdGenerator, ShipIdGenerator, ShipBattleIdGenerator, RosterData, Roster, ShipInventory, Ship, ShipData, MapLocationData, MapLocation, Map, MapData } from "../src/codegen/index.sol";
import { ItemIdQuantityPair } from "../src/systems/ItemIdQuantityPair.sol";
import { UpdateLocationParams } from "../src/systems/UpdateLocationParams.sol";
import { Coordinates } from "../src/systems/Coordinates.sol";
import { RosterUtil } from "../src/utils/RosterUtil.sol";

contract ShipInventoryTest is Script {
  //
  // forge script ShipInventoryTest.s.sol:ShipInventoryTest --sig "run(address,uint256)" 0x593ad505023ea24371f8f628b251e0667308840f 25530 --broadcast --rpc-url https://odyssey.storyrpc.io
  //
  function run(address worldAddress, uint256 shipId) external {
    if (shipId < 1) {
      console.log("Please input the ship id.");
      return;
    }
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
    console.log("Ship Id:%d", shipId);
    ShipData memory shipData = Ship.get(shipId);
    uint64 shipInventoryCount = ShipInventoryCount.get(shipId);
    if (shipInventoryCount < 1) {
      console.log("The ship has no inventory.");
    } else {
      for (uint64 i = 0; i < shipInventoryCount; i++) {
        ShipInventoryData memory shipInventoryData = ShipInventory.get(shipId, i);
        console.log("Item Id:%d,quantity:%d", shipInventoryData.inventoryItemId, shipInventoryData.inventoryQuantity);
      }
    }
    vm.stopBroadcast();
  }

  function createIslandResources() internal pure returns (ItemIdQuantityPair[] memory) {
    ItemIdQuantityPair[] memory resources = new ItemIdQuantityPair[](3);
    resources[0] = ItemIdQuantityPair(2, 101); // CottonSeeds
    resources[1] = ItemIdQuantityPair(2000000001, 101); // ResourceTypeWoodcutting
    resources[2] = ItemIdQuantityPair(2000000003, 101); // ResourceTypeMining
    return resources;
  }
}
