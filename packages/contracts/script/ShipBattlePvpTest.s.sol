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
import { PlayerIdGenerator, ShipIdGenerator, ShipBattleIdGenerator, RosterData, Roster } from "../src/codegen/index.sol";
import { ItemIdQuantityPair } from "../src/systems/ItemIdQuantityPair.sol";
import { RosterUtil } from "../src/utils/RosterUtil.sol";

import { Coordinates } from "../src/systems/Coordinates.sol";
import { ShipBattleLocationParams } from "../src/systems/ShipBattleLocationParams.sol";

contract ShipBattlePvpTest is Script {
  //
  // forge script ShipBattlePvpTest.s.sol:ShipBattlePvpTest --sig "run(address)" 0x593ad505023ea24371f8f628b251e0667308840f --broadcast --rpc-url https://odyssey.storyrpc.io/
  // forge script ShipBattlePvpTest.s.sol:ShipBattlePvpTest --sig "run(address)" 0x776086899eab4ee3953b7c037b2c0a13c7a1deed --broadcast --rpc-url https://odyssey.storyrpc.io/
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

    // Energy energyToken = new Energy(deployerAddress);
    // address energyTokenAddress = address(energyToken);
    // console.log("ENERGY Token address:", energyTokenAddress);

    // IERC20 energyIErc20 = IERC20(energyTokenAddress);
    // energyIErc20.approve(systemAddress, 10000 * 10 ** 18);
    // console.log("Approved AggregatorServiceSystem to spend ENERGY tokens");

    IWorld world = IWorld(worldAddress);
    // world.app__energyTokenCreate(energyTokenAddress);
    // console.log("Set ENERGY token address for the world");

    // uint256 playerId = 1;

    // uint32 firstIslandX = 2147483647;
    // uint32 firstIslandY = 2147483647;
    // uint32 currentRosterSequenceNumber = 1;
    // (uint32 originCoordinatesX, uint32 originCoordinatesY) = RosterUtil.getRosterOriginCoordinates(
    //   firstIslandX,
    //   firstIslandY,
    //   currentRosterSequenceNumber
    // );

    // RosterData memory rosterData = Roster.get(playerId, currentRosterSequenceNumber);
    // console.log("Roster speed:", rosterData.speed);

    // //return;
    // // //////////////////////////////////////////////////////////////

    // uint32 targetCoordinatesX = originCoordinatesX + 10;
    // uint32 targetCoordinatesY = originCoordinatesY + 10;

    // // //////////////////////////////////////////////////////////////
    // uint256 environmentRosterPlayerId = type(uint256).max;
    // uint32 environmentRosterSequenceNumber = 100;
    // uint32 environmentRosterCoordinatesX = originCoordinatesX;
    // uint32 environmentRosterCoordinatesY = originCoordinatesX;
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
    // console.log("Created another environment roster");

    //return;

    // world.app__initiateShipBattle(
    //   playerId,
    //   playerId,
    //   currentRosterSequenceNumber,
    //   environmentRosterPlayerId,
    //   environmentRosterSequenceNumber,
    //   environmentRosterCoordinatesX,
    //   environmentRosterCoordinatesY,
    //   environmentRosterCoordinatesX,
    //   environmentRosterCoordinatesY
    // );
    // console.log("Initiated a ship battle");

    // uint256 shipBattleId = ShipBattleIdGenerator.get();
    // world.app__shipBattleMakeMove(shipBattleId, 1);
    // console.log("Made a move in the ship battle");

    uint256 playerId = 1;
    uint256 initiatorRosterPlayerId = 1;
    uint32 initiatorRosterSequenceNumber = 1;
    uint256 responderRosterPlayerId = 6;
    uint32 responderRosterSequenceNumber = 2;

    world.app__shipBattleServiceInitiateBattleAndAutoPlayTillEnd(
      playerId,
      playerId,
      initiatorRosterSequenceNumber,
      responderRosterPlayerId,
      responderRosterSequenceNumber,
      ShipBattleLocationParams({
        initiatorCoordinates: Coordinates({ x: 2147485887, y: 2147478216 }),
        updatedInitiatorSailSeg: 4,
        responderCoordinates: Coordinates({ x: 0, y: 0 }),
        updatedResponderSailSeg: 0,
        updatedAt: 1734683953
      })
    );
    console.log("Initiated a ship battle and auto played till end");

    // world.app__shipBattleTakeLoot(1, 1); // ShipBattleId, Choice
    // console.log("Took loot from the ship battle");
    /*
    cast send --private-key __YOUR_PRIVATE_KEY__ \
    __WORLD_CONTRACT_ADDRESS__ \
    "app__shipBattleTakeLoot(uint256,uint8)"\
    '1' '1'
    */

    vm.stopBroadcast();
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
