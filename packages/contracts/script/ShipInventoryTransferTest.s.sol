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

contract ShipInventoryTransferTest is Script {
  //
  // forge script script/ShipInventoryTransferTest.s.sol:ShipInventoryTransferTest --sig "run(address)" <WORLD_ADDRESS> --broadcast --rpc-url http://localhost:8545
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

    uint32 unassignedShipsRosterSequenceNumber = 0;
    uint256 toRosterPlayerId = playerId;
    uint32 toRosterSequenceNumber = 1;

    uint256 playerShipId; // = ShipIdGenerator.get();
    RosterData memory rosterData = Roster.get(toRosterPlayerId, toRosterSequenceNumber);
    playerShipId = rosterData.shipIds[0];
    console.log("Player ship ID:", playerShipId);

    uint32 firstIslandX = 2147483647;
    uint32 firstIslandY = 2147483647;
    uint32 currentRosterSequenceNumber = 1;
    (uint32 originCoordinatesX, uint32 originCoordinatesY) = RosterUtil.getRosterOriginCoordinates(
      firstIslandX,
      firstIslandY,
      currentRosterSequenceNumber
    );

    /*
    cast send --private-key __YOUR_PRIVATE_KEY__ \
    __WORLD_CONTRACT_ADDRESS__ \
    "app__rosterPutInShipInventory(uint256,uint32,uint256,(uint32,uint32)[],uint32,uint32)" \
    '1' '1' '5' '[(102,5),(200,5)]' '2147483797' '2147483797'
    */

    // //uint32[] memory shipMaterialItemIds = new uint32[](2);
    // //shipMaterialItemIds[0] = 102; // Cottons
    // //shipMaterialItemIds[1] = 200; // NormalLogs
    ItemIdQuantityPair[] memory itemIdQuantityPairs = new ItemIdQuantityPair[](2);
    itemIdQuantityPairs[0] = ItemIdQuantityPair(102, 10); // 10 Cottons
    itemIdQuantityPairs[1] = ItemIdQuantityPair(200, 20); // 20 NormalLogs
    console.log("Coordinates:", originCoordinatesX, originCoordinatesY);
    world.app__rosterPutInShipInventory(
      toRosterPlayerId,
      toRosterSequenceNumber,
      playerShipId,
      itemIdQuantityPairs,
      originCoordinatesX,
      originCoordinatesY
    );
    console.log("Put in ship inventory");

    world.app__rosterTakeOutShipInventory(
      toRosterPlayerId,
      toRosterSequenceNumber,
      playerShipId,
      itemIdQuantityPairs,
      originCoordinatesX,
      originCoordinatesY
    );
    console.log("Taken out ship inventory");

    world.app__rosterPutInShipInventory(
      toRosterPlayerId,
      toRosterSequenceNumber,
      playerShipId,
      itemIdQuantityPairs,
      originCoordinatesX,
      originCoordinatesY
    );
    console.log("Put in ship inventory again");

    world.app__rosterTransferShipInventory(
      toRosterPlayerId,
      toRosterSequenceNumber,
      playerShipId,
      playerShipId,
      itemIdQuantityPairs
    );
    console.log("Transferred ship inventory");

    vm.stopBroadcast();
  }
}
