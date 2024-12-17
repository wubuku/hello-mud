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
import { SpeedUtil } from "../src/utils/SpeedUtil.sol";

contract ManualSmokeTest is Script {
  //
  // forge script ManualSmokeTest.s.sol:ManualSmokeTest --sig "run(address)" 0x8d8b6b8414e1e3dcfd4168561b9be6bd3bf6ec4b --broadcast --rpc-url http://127.0.0.1:8545
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

    // Energy energyToken = new Energy(deployerAddress);
    // address energyTokenAddress = address(energyToken);
    // console.log("ENERGY Token address:", energyTokenAddress);

    // IERC20 energyIErc20 = IERC20(energyTokenAddress);
    // energyIErc20.approve(systemAddress, 10000 * 10 ** 18);
    // console.log("Approved AggregatorServiceSystem to spend ENERGY tokens");

    IWorld world = IWorld(worldAddress);
    // world.app__energyTokenCreate(energyTokenAddress);
    // console.log("Set ENERGY token address for the world");

    uint256 playerId = 1;

    /*
    cast send --private-key __YOUR_PRIVATE_KEY__ \
    __WORLD_CONTRACT_ADDRESS__ \
    "app__skillProcessCompleteCreation(uint8,uint256,uint8)" \
    '3' '1' '0'
    */
    world.app__skillProcessCompleteCreation(uint8(SkillType.MINING), playerId, 0); // skill type 3 is MINING
    console.log("Completed skill process creation for MINING");

    /*
    cast send --private-key __YOUR_PRIVATE_KEY__ \
    __WORLD_CONTRACT_ADDRESS__ \
    "app__skillProcessCompleteProduction(uint8,uint256,uint8)" \
    '0' '1' '0'
    */
    // world.app__skillProcessCompleteProduction(uint8(SkillType.FARMING), playerId, 0); // skill type 0 is FARMING
    // console.log("Completed skill process production for FARMING");

    /*
    cast send --private-key __YOUR_PRIVATE_KEY__ \
    __WORLD_CONTRACT_ADDRESS__ \
    "app__skillProcessCompleteShipProduction(uint8,uint256,uint8)" \
    '6' '1' '0'
    */
    world.app__skillProcessCompleteShipProduction(uint8(SkillType.CRAFTING), playerId, 0); // skill type 6 is CRAFTING
    console.log("Completed skill process ship production for CRAFTING");

    uint256 playerShipId = ShipIdGenerator.get();
    console.log("Player ship ID:", playerShipId);

    uint32 unassignedShipsRosterSequenceNumber = 0;
    uint256 toRosterPlayerId = playerId;
    uint32 toRosterSequenceNumber = 1;
    //playerShipId = 11111; // 11111 is a ship id that doesn't exist, just for test fail case

    uint32 locationUpdateParamsCoordinatesX = 0;//todo
    uint32 locationUpdateParamsCoordinatesY = 0;//todo
    uint16 locationUpdateParamsUpdatedSailSeg = 0;//todo
    uint32 locationUpdateParamsToRosterCoordinatesX = 0;//todo
    uint32 locationUpdateParamsToRosterCoordinatesY = 0;//todo
    uint16 locationUpdateParamsToRosterUpdatedSailSeg = 0;//todo
    uint64 locationUpdateParamsUpdatedAt = 0;//todo

    world.app__rosterTransferShip(
      playerId,
      unassignedShipsRosterSequenceNumber,
      playerShipId,
      toRosterPlayerId,
      toRosterSequenceNumber,
      type(uint64).max,
      locationUpdateParamsCoordinatesX,
      locationUpdateParamsCoordinatesY,
      locationUpdateParamsUpdatedSailSeg,
      locationUpdateParamsToRosterCoordinatesX,
      locationUpdateParamsToRosterCoordinatesY,
      locationUpdateParamsToRosterUpdatedSailSeg,
      locationUpdateParamsUpdatedAt
    );
    console.log("Transferred ship from unassigned ships to first roster");

    // Test transfer multiple ships
    uint256[] memory shipIds = new uint256[](1);
    shipIds[0] = playerShipId;
    world.app__rosterTransferMultiShips(
      toRosterPlayerId,
      toRosterSequenceNumber,
      shipIds,
      playerId,
      unassignedShipsRosterSequenceNumber,
      type(uint64).max
    );
    console.log("Transferred ship from first roster to unassigned ships");

    world.app__rosterTransferMultiShips(
      playerId,
      unassignedShipsRosterSequenceNumber,
      shipIds,
      toRosterPlayerId,
      toRosterSequenceNumber,
      type(uint64).max
    );
    console.log("Transferred ship from unassigned ships to first roster again");

    uint32 firstIslandX = 2147483647;
    uint32 firstIslandY = 2147483647;
    uint32 currentRosterSequenceNumber = 1;
    (uint32 originCoordinatesX, uint32 originCoordinatesY) = RosterUtil.getRosterOriginCoordinates(
      firstIslandX,
      firstIslandY,
      currentRosterSequenceNumber
    );

    RosterData memory rosterData = Roster.get(playerId, currentRosterSequenceNumber);
    console.log("Roster speed:", rosterData.speed);

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
