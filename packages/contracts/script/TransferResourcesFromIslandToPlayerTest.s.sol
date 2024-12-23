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
import { SailIntPointData, PlayerInventoryData, PlayerInventory, PlayerInventoryCount, PlayerData, Player, MapLocationData, MapLocation, ShipInventoryData, ShipInventoryCount, ShipInventory, PlayerIdGenerator, ShipIdGenerator, ShipBattleIdGenerator, RosterData, Roster } from "../src/codegen/index.sol";
import { ItemIdQuantityPair } from "../src/systems/ItemIdQuantityPair.sol";
import { RosterUtil } from "../src/utils/RosterUtil.sol";

import { Coordinates } from "../src/systems/Coordinates.sol";
import { ShipBattleLocationParams } from "../src/systems/ShipBattleLocationParams.sol";
import { UpdateLocationParams } from "../src/systems/UpdateLocationParams.sol";
import { SailIntPointLib } from "../src/systems/SailIntPointLib.sol";

contract TransferResourcesFromIslandToPlayerTest is Script {
  //
  // forge script TransferResourcesFromIslandToPlayerTest.s.sol:TransferResourcesFromIslandToPlayerTest --sig "run(address)" 0x593ad505023ea24371f8f628b251e0667308840f --broadcast --rpc-url https://odyssey.storyrpc.io/
  // forge script TransferResourcesFromIslandToPlayerTest.s.sol:TransferResourcesFromIslandToPlayerTest --sig "run(address)" 0x776086899eab4ee3953b7c037b2c0a13c7a1deed --broadcast --rpc-url https://odyssey.storyrpc.io/
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

    IWorld world = IWorld(worldAddress);

    uint256 playerId = 1;
    PlayerData memory playerData = Player.get(playerId);
    MapLocationData memory mapLocationData = MapLocation.get(playerData.claimedIslandX, playerData.claimedIslandY);
    console.log("Island(x:%d,y:%d)'s inventory:", playerData.claimedIslandX, playerData.claimedIslandY);
    // logIslandInventory(mapLocationData);
    logPlayerEnventory(playerId);
    uint32 sequenceNumber = 1;

    RosterData memory rosterData = Roster.get(playerId, sequenceNumber);
    console.log("The roster's location:");
    logRosterLocation(rosterData);
    console.log("The roster's status:");
    logRosterStatus(rosterData);
    // Roster.setTargetCoordinatesX(playerId, sequenceNumber, rosterData.targetCoordinatesX + 100);
    // Roster.setTargetCoordinatesY(playerId, sequenceNumber, rosterData.targetCoordinatesY + 100);

    SailIntPointData[] memory sailIntermediatePoints = SailIntPointLib.getAllSailIntermediatePoints(
      playerId,
      sequenceNumber
    );
    if (sailIntermediatePoints.length > 0) {
      console.log("The roster has %d IntermediatePoints", sailIntermediatePoints.length);
      for (uint i = 0; i < sailIntermediatePoints.length; i++) {
        console.log(
          "coordinatesX:%d,coordinatesY:%d,SegmentShouldStartAt:%d",
          sailIntermediatePoints[i].coordinatesX,
          sailIntermediatePoints[i].coordinatesY,
          sailIntermediatePoints[i].segmentShouldStartAt
        );
      }
    } else {
      console.log("The roster has not IntermediatePoints");
    }

    uint256 shipId = 14423;
    logShipEnventory(shipId);
    Coordinates memory coordinates = Coordinates(2147482687, 2147485247);
    UpdateLocationParams memory updateLocationParams = UpdateLocationParams(coordinates, 3, 1734704151);
    ItemIdQuantityPair[] memory itemIdQuantityPairs = new ItemIdQuantityPair[](3);
    itemIdQuantityPairs[0] = ItemIdQuantityPair(301, 2);
    itemIdQuantityPairs[1] = ItemIdQuantityPair(200, 0);
    itemIdQuantityPairs[2] = ItemIdQuantityPair(102, 0);
    console.log("Transfer the following resources to the ship(id:%d)", shipId);
    for (uint i = 0; i < itemIdQuantityPairs.length; i++) {
      console.log("   ItemId:%d,quantity:%d", itemIdQuantityPairs[i].itemId, itemIdQuantityPairs[i].quantity);
    }
    console.log("Begin transfer");

    world.app__rosterPutInShipInventory(playerId, sequenceNumber, shipId, itemIdQuantityPairs, updateLocationParams);
    console.log("Transfer end");
    mapLocationData = MapLocation.get(playerData.claimedIslandX, playerData.claimedIslandY);
    console.log("The island's inventory:");
    logPlayerEnventory(playerId);
    console.log("The ship's inventory:");
    logShipEnventory(shipId);
    console.log("The roster's location:");
    rosterData = Roster.get(playerId, sequenceNumber);
    logRosterLocation(rosterData);
    console.log("The roster's status:");
    logRosterStatus(rosterData);
    vm.stopBroadcast();
  }
  function logPlayerEnventory(uint256 playerId) internal view {
    uint64 playerInventoryCount = PlayerInventoryCount.get(playerId);
    for (uint64 i = 0; i < playerInventoryCount; i++) {
      PlayerInventoryData memory playerInventoryData = PlayerInventory.get(playerId, i);
      console.log(
        "   ItemId:%d,quantity:%d",
        playerInventoryData.inventoryItemId,
        playerInventoryData.inventoryQuantity
      );
    }
  }

  function logShipEnventory(uint256 shipId) internal view {
    uint64 shipInventoryCount = ShipInventoryCount.get(shipId);
    console.log("Ship Id:%d's inventory:", shipId);
    for (uint64 i = 0; i < shipInventoryCount; i++) {
      ShipInventoryData memory shipInventoryData = ShipInventory.get(shipId, i);
      console.log("   ItemId:%d,quantity:%d", shipInventoryData.inventoryItemId, shipInventoryData.inventoryQuantity);
    }
  }
  //function logShipData(ShipData memory shipData) view interal {}

  function logRosterStatus(RosterData memory rosterData) internal view {
    if (rosterData.status == 1) {
      console.log("UNDERWAY");
    } else if (rosterData.status == 255) {
      console.log("AT_ANCHOR");
    } else if (rosterData.status == 2) {
      console.log("IN_BATTLE");
    } else if (rosterData.status == 3) {
      console.log("DESTROYED");
    } else {
      console.log("unknown");
    }
  }
  function logRosterLocation(RosterData memory responseRosterData) internal view {
    console.log("Roster's currentSailSegment is %d", responseRosterData.currentSailSegment);
    console.log("Roster's setSailAt is %d", responseRosterData.setSailAt);
    console.log("Roster's coordinatesUpdatedAt is %d", responseRosterData.coordinatesUpdatedAt);
    console.log("Roster's sailDuration is %d", responseRosterData.sailDuration);
    console.log(
      "originCoordinatesX:%d,originCoordinatesY:%d",
      responseRosterData.originCoordinatesX,
      responseRosterData.originCoordinatesY
    );
    console.log(
      "UpdatedCoordinatesX:%d,UpdatedCoordinatesY:%d",
      responseRosterData.updatedCoordinatesX,
      responseRosterData.updatedCoordinatesY
    );
    console.log(
      "targetCoordinatesX:%d,targetCoordinatesY:%d",
      responseRosterData.targetCoordinatesX,
      responseRosterData.targetCoordinatesY
    );
  }
  function logIslandInventory(MapLocationData memory mapLocationData) internal view {
    for (uint i = 0; i < mapLocationData.resourcesItemIds.length; i++) {
      console.log(
        "   ItemId:%d,quantity:%d",
        mapLocationData.resourcesItemIds[i],
        mapLocationData.resourcesQuantities[i]
      );
    }
  }

  /*
    % cast sig 'InitiatorNotDestroyed(uint256,uint32)'                  
    0xf3b52f34
    % cast sig 'ResponderNotDestroyed(uint256,uint32)'
    0x6e9fb9f2
    % cast sig 'InvalidWinner(uint8)'       
    0x4b08dceb
    % cast sig 'BattleNotEnded(uint8)'
    0xe9971ad4
    % cast sig 'InvalidLoserStatus(uint8)'
    0x4964fb7c
    % cast sig 'WinnerNotSet()'
    0xd5881ca9
    % cast sig 'PlayerHasNoClaimedIsland()'
    0x716ae8d5
    % cast sig 'BattleEndedAtNotSet()'
    0xe841ff82
  */
}
