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
import { ShipData, Ship, PlayerIdGenerator, ShipIdGenerator, ShipBattleIdGenerator, RosterData, Roster, Player, PlayerData } from "../src/codegen/index.sol";
import { ItemIdQuantityPair } from "../src/systems/ItemIdQuantityPair.sol";
import { RosterUtil } from "../src/utils/RosterUtil.sol";
import { DirectRouteUtil } from "../src/utils/DirectRouteUtil.sol";
import { TwoRostersLocationUpdateParams } from "../src/systems/TwoRostersLocationUpdateParams.sol";
import { Coordinates } from "../src/systems/Coordinates.sol";
import { SpeedUtil } from "../src/utils/SpeedUtil.sol";

contract BugTest is Script {
  //
  // forge script BugTest.s.sol:BugTest --sig "run(address)" 0x9771401d9abfae61b9d90bfb248bac9fed4d586d --broadcast --rpc-url http://127.0.0.1:8545
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

    uint256 playerId = 1;
    IWorld world = IWorld(worldAddress);

    uint256 lastShipId = 1;
    if (lastShipId == 0) {
      world.app__skillProcessCompleteShipProduction(uint8(SkillType.CRAFTING), playerId, 0); // skill type 6 is CRAFTING
      console.log("Completed skill process ship production for CRAFTING");

      uint32 sequenceNumber = 0;
      RosterData memory rosterData = Roster.get(playerId, sequenceNumber);
      if (rosterData.shipIds.length < 0) {
        vm.stopBroadcast();
        console.log("We can't get the crafted ship");
        return;
      }
      lastShipId = rosterData.shipIds[rosterData.shipIds.length - 1];
    }
    console.log("The ship's id:%d", lastShipId);
    PlayerData memory player = Player.get(playerId);
    console.log("Island's X=%d,Y=%d", player.claimedIslandX, player.claimedIslandY);
    //编号为1的船队的信息
    uint32 roster1SequenceNumber = 1;
    RosterData memory roster1 = Roster.get(playerId, roster1SequenceNumber);
    console.log("Roster1's X=%d,Y=%d", roster1.updatedCoordinatesX, roster1.updatedCoordinatesY);
    uint256 distance = DirectRouteUtil.getDistance(
      player.claimedIslandX,
      player.claimedIslandY,
      roster1.updatedCoordinatesX,
      roster1.updatedCoordinatesY
    );
    console.log("Distance=%d", distance);
    ShipData memory ship = Ship.get(lastShipId);
    uint32 originalSequenceNumber = ship.rosterSequenceNumber;
    console.log("ship's rosterSequenceNumber is %d", ship.rosterSequenceNumber);

    uint32 toRosterSequenceNumber = originalSequenceNumber == 0 ? 1 : 0;

    Roster.setUpdatedCoordinatesX(playerId, roster1SequenceNumber, player.claimedIslandX + 5000);
    roster1 = Roster.get(playerId, roster1SequenceNumber);
    console.log("Roster1's changed to X=%d,Y=%d", roster1.updatedCoordinatesX, roster1.updatedCoordinatesY);
    distance = DirectRouteUtil.getDistance(
      player.claimedIslandX,
      player.claimedIslandY,
      roster1.updatedCoordinatesX,
      roster1.updatedCoordinatesY
    );
    console.log("Distance=%d", distance);

    uint32 locationUpdateParamsCoordinatesX = 0; //todo
    uint32 locationUpdateParamsCoordinatesY = 0; //todo
    uint16 locationUpdateParamsUpdatedSailSeg = 0; //todo
    uint32 locationUpdateParamsToRosterCoordinatesX = 0; //todo
    uint32 locationUpdateParamsToRosterCoordinatesY = 0; //todo
    uint16 locationUpdateParamsToRosterUpdatedSailSeg = 0; //todo
    uint64 locationUpdateParamsUpdatedAt = 0; //todo

    TwoRostersLocationUpdateParams memory locationUpdateParams = TwoRostersLocationUpdateParams({
      coordinates: Coordinates(locationUpdateParamsCoordinatesX, locationUpdateParamsCoordinatesY),
      updatedSailSeg: locationUpdateParamsUpdatedSailSeg,
      toRosterCoordinates: Coordinates(
        locationUpdateParamsToRosterCoordinatesX,
        locationUpdateParamsToRosterCoordinatesY
      ),
      toRosterUpdatedSailSeg: locationUpdateParamsToRosterUpdatedSailSeg,
      updatedAt: locationUpdateParamsUpdatedAt
    });
    console.log("Transfer ship from %d to %d", originalSequenceNumber, toRosterSequenceNumber);
    world.app__rosterTransferShip(
      playerId,
      ship.rosterSequenceNumber,
      lastShipId,
      playerId,
      toRosterSequenceNumber,
      type(uint64).max,
      locationUpdateParams
    );
    ship = Ship.get(lastShipId);
    console.log("After Trasferring,ship's rosterSequenceNumber is %d", ship.rosterSequenceNumber);
    vm.stopBroadcast();
  }
}
