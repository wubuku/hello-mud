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
import { ShipBattleData, ShipBattle, ShipData, Ship, PlayerIdGenerator, ShipIdGenerator, ShipBattleIdGenerator, RosterData, Roster, Player, PlayerData } from "../src/codegen/index.sol";
import { ItemIdQuantityPair } from "../src/systems/ItemIdQuantityPair.sol";
import { RosterUtil } from "../src/utils/RosterUtil.sol";
import { DirectRouteUtil } from "../src/utils/DirectRouteUtil.sol";
import { TwoRostersLocationUpdateParams } from "../src/systems/TwoRostersLocationUpdateParams.sol";
import { Coordinates } from "../src/systems/Coordinates.sol";
import { RosterId } from "../src/systems/RosterId.sol";
import { SpeedUtil } from "../src/utils/SpeedUtil.sol";

contract ShowRosterInfo is Script {
  //
  // forge script ShowRosterInfo.s.sol:ShowRosterInfo --sig "run(address)" 0x593ad505023ea24371f8f628b251e0667308840f --broadcast --rpc-url https://odyssey.storyrpc.io/
  // forge script ShowRosterInfo.s.sol:ShowRosterInfo --sig "run(address)" 0x776086899eab4ee3953b7c037b2c0a13c7a1deed --broadcast --rpc-url https://odyssey.storyrpc.io/
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

    IWorld world = IWorld(worldAddress);
    // uint256 playerId = 376;
    // PlayerData memory playerData = Player.get(playerId);
    // console.log("Player's name:%s", playerData.name);

    //uint256[2] memory battleIds = [uint256(641), uint256(852)];
    //RosterId[2] memory rosterIds = [RosterId(1, 1), RosterId(6, 2)];
    RosterId[1] memory rosterIds = [RosterId(1, 1)];
    //uint256[1] memory battleIds = [uint256(641)];
    for (uint x = 0; x < rosterIds.length; x++) {
      console.log("---------------------------------------------");
      uint256 playerId = rosterIds[x].playerId;
      uint32 sequenceNumber = rosterIds[x].sequenceNumber;
      console.log("RosterId[PlayerId:%d,SequenceNumber:%d]", playerId, sequenceNumber);
      logPlayerData(playerId);
      RosterData memory rosterData = Roster.get(playerId, sequenceNumber);
      logRosterStatus(rosterData);
      logRosterLocation(rosterData);
      console.log("Battle Id:%d", rosterData.shipBattleId);
      if (rosterData.shipBattleId != 0) {
        ShipBattleData memory shipBattleData = ShipBattle.get(rosterData.shipBattleId);
        console.log("Initiator Roster PlayerId:%d", shipBattleData.initiatorRosterPlayerId);
        // if (shipBattleData.initiatorRosterPlayerId != playerId) {
        logPlayerData(shipBattleData.initiatorRosterPlayerId);
        // }
        console.log("Initiator Roster SequenceNumber:%d", shipBattleData.initiatorRosterSequenceNumber);
        console.log("Responder Roster PlayerId:%d", shipBattleData.responderRosterPlayerId);
        logPlayerData(shipBattleData.responderRosterPlayerId);
        console.log("Responder Roster SequenceNumber:%d", shipBattleData.responderRosterSequenceNumber);
        console.log("status:%d", shipBattleData.status);
        if (shipBattleData.status == 1) {
          console.log("ENDED");
        } else if (shipBattleData.status == 2) {
          console.log("LOOTED");
        } else if (shipBattleData.status == 0) {
          console.log("IN_PROGRESS");
        } else {
          console.log("unknown");
        }
        console.log("Winner:%s", shipBattleData.winner == 1 ? "initiator" : "responder");
        rosterData = Roster.get(shipBattleData.initiatorRosterPlayerId, shipBattleData.initiatorRosterSequenceNumber);
        console.log("The initiator roster has %d ships", rosterData.shipIds.length);
        console.log("The initiator roster's status:%d", rosterData.status);
        logRosterStatus(rosterData);
        logRosterLocation(rosterData);
        for (uint i = 0; i < rosterData.shipIds.length; i++) {
          console.log("Ship Id:%d", rosterData.shipIds[i]);
          ShipData memory shipData = Ship.get(rosterData.shipIds[i]);
          console.log("    healthPoints:%d,speed:%d", shipData.healthPoints, shipData.speed);
          console.log("    attack:%d,protection:%d", shipData.attack, shipData.protection);
        } // ... existing code ...
        RosterData memory responseRosterData = Roster.get(
          shipBattleData.responderRosterPlayerId,
          shipBattleData.responderRosterSequenceNumber
        );
        console.log("The responder roster has %d ships", responseRosterData.shipIds.length);
        console.log("The responder roster's status:%d", responseRosterData.status);
        logRosterStatus(responseRosterData);
        logRosterLocation(responseRosterData);
        for (uint i = 0; i < responseRosterData.shipIds.length; i++) {
          console.log("Ship Id:%d", responseRosterData.shipIds[i]);
          ShipData memory shipData = Ship.get(responseRosterData.shipIds[i]);
          console.log("    healthPoints:%d,speed:%d", shipData.healthPoints, shipData.speed);
          console.log("    attack:%d,protection:%d", shipData.attack, shipData.protection);
        }
      }
    }
    vm.stopBroadcast();
  }
  function logPlayerData(uint256 playerId) internal view {
    PlayerData memory playerData = Player.get(playerId);
    console.log("Player's name:%s", playerData.name);
  }
  function logRosterStatus(RosterData memory rosterData) internal view {
    if (rosterData.status == 1) {
      console.log("AT_ANCHOR");
    } else if (rosterData.status == 255) {
      console.log("UNDERWAY");
    } else if (rosterData.status == 2) {
      console.log("IN_BATTLE");
    } else if (rosterData.status == 3) {
      console.log("DESTROYED");
    } else {
      console.log("unknown");
    }
  }
  function logRosterLocation(RosterData memory responseRosterData) internal view {
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
}
