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

contract InventoryTest is Script {
  //
  // forge script InventoryTest.s.sol:InventoryTest --sig "run(address)" 0xc600b6fcdd37be933e2d296852d5b50a5d20f096 --broadcast --rpc-url "https://odyssey.storyrpc.io/"
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
      vm.stopBroadcast();
      return;
    } else {
      console.log(
        "existing:%s,gatheredAt:%d,occupiedBy:%d",
        mapLocationData.existing,
        mapLocationData.gatheredAt,
        mapLocationData.occupiedBy
      );
    }
    uint32[] memory itemIds;
    uint32[] memory quantities;
    if (mapLocationData.resourcesItemIds.length < 1) {
      console.log("There are nothing on the island.");
      ItemIdQuantityPair[] memory resources = createIslandResources();
      itemIds = new uint32[](resources.length);
      quantities = new uint32[](resources.length);
      for (uint i = 0; i < resources.length; i++) {
        itemIds[i] = resources[i].itemId;
        quantities[i] = resources[i].quantity;
      }
      //world.app__mapAirdrop(playerData.claimedIslandX, playerData.claimedIslandY, itemIds, quantities);
      console.log("So airdrop some resources to the island...");
      MapLocation.set(
        playerData.claimedIslandX,
        playerData.claimedIslandY,
        0,
        playerId,
        mapLocationData.gatheredAt,
        true,
        itemIds,
        quantities
      );
      console.log("...Done");
    } else {
      itemIds = mapLocationData.resourcesItemIds;
      quantities = mapLocationData.resourcesQuantities;
    }
    console.log("The resources of the island:");
    for (uint i = 0; i < itemIds.length; i++) {
      console.log("Item id:%d,quantity:%d", itemIds[i], quantities[i]);
    }
    //ShipInventory.get(shipId, inventoryIndex);
    // 查询当前账户编号为 1（索引为 0 的为 unsigned）的船队
    uint32 sequenceNumber = 1;
    RosterData memory rosterData = Roster.get(playerId, sequenceNumber);
    if (rosterData.shipIds.length < 1) {
      console.log("Roster%d has no ships", sequenceNumber + 1);
      vm.stopBroadcast();
      return;
    }
    console.log("Roster%d has %d ships", sequenceNumber + 1, rosterData.shipIds.length);
    uint256 lastShipInTheRoster = rosterData.shipIds[rosterData.shipIds.length - 1];
    uint64 shipInventoryCount = ShipInventoryCount.get(lastShipInTheRoster);
    if (shipInventoryCount < 1) {
      console.log("Ship id(%d): has no inventory", lastShipInTheRoster);
    } else {
      for (uint64 i = 0; i < shipInventoryCount - 1; i++) {
        ShipInventoryData memory shipInventoryData = ShipInventory.get(lastShipInTheRoster, i);
        console.log("Item Id:%d,Quantity:%d", shipInventoryData.inventoryItemId, shipInventoryData.inventoryQuantity);
      }
    }
    ItemIdQuantityPair[] memory itemIdQuantityPairs = new ItemIdQuantityPair[](itemIds.length);
    for (uint i = 0; i < itemIds.length; i++) {
      itemIdQuantityPairs[i] = ItemIdQuantityPair(itemIds[i], quantities[i]);
    }
    console.log(
      "Transfer resources from island to ship(Roster:%d,Index:%d,ShipId:%d)",
      sequenceNumber + 1,
      rosterData.shipIds.length - 1,
      lastShipInTheRoster
    );
    Coordinates memory coordinates = Coordinates(0, 0);
    UpdateLocationParams memory updateLocationParams = UpdateLocationParams(coordinates, 0, 0);
    world.app__rosterPutInShipInventory(
      playerId,
      sequenceNumber,
      lastShipInTheRoster,
      itemIdQuantityPairs,
      updateLocationParams
    );

    console.log("Transferring resources from island to ship is done,now the ship has:");
    shipInventoryCount = ShipInventoryCount.get(lastShipInTheRoster);
    for (uint64 i = 0; i < shipInventoryCount - 1; i++) {
      ShipInventoryData memory shipInventoryData = ShipInventory.get(lastShipInTheRoster, i);
      console.log("Item Id:%d,Quantity:%d", shipInventoryData.inventoryItemId, shipInventoryData.inventoryQuantity);
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
