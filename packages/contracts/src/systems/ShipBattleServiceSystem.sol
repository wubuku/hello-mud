// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { System } from "@latticexyz/world/src/System.sol";
import { ShipBattleSystem } from "./ShipBattleSystem.sol";
import { BattleStatus } from "./BattleStatus.sol";
import { ShipBattleCommand } from "./ShipBattleCommand.sol";
import { ShipBattle } from "../codegen/index.sol";
import { IWorldContextConsumer } from "@latticexyz/world/src/IWorldContextConsumer.sol";
import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";
import { ResourceId, WorldResourceIdLib, WorldResourceIdInstance } from "@latticexyz/world/src/WorldResourceId.sol";
import { RESOURCE_SYSTEM } from "@latticexyz/world/src/worldResourceTypes.sol";

contract ShipBattleServiceSystem is System {
  uint256 constant MAX_NUMBER_OF_ROUNDS = 100;

  function shipBattleServiceInitiateBattleAndAutoPlayTillEnd(
    uint256 playerId,
    uint256 initiatorRosterPlayerId,
    uint32 initiatorRosterSequenceNumber,
    uint256 responderRosterPlayerId,
    uint32 responderRosterSequenceNumber,
    int32 initiatorCoordinatesX,
    int32 initiatorCoordinatesY,
    int32 responderCoordinatesX,
    int32 responderCoordinatesY
  ) public {
    IWorldContextConsumer ctx = IWorldContextConsumer(address(this));
    IBaseWorld world = IBaseWorld(ctx._world());
    ResourceId shipBattleSystemId = WorldResourceIdLib.encode({
      typeId: RESOURCE_SYSTEM,
      namespace: "app",
      name: "ShipBattleSystem"
    });
    bytes memory shipBattleInitiateBattleReturnData = world.callFrom(
      ctx._msgSender(),
      shipBattleSystemId,
      abi.encodeCall(
        ShipBattleSystem.shipBattleInitiateBattle,
        (
          playerId,
          initiatorRosterPlayerId,
          initiatorRosterSequenceNumber,
          responderRosterPlayerId,
          responderRosterSequenceNumber,
          initiatorCoordinatesX,
          initiatorCoordinatesY,
          responderCoordinatesX,
          responderCoordinatesY
        )
      )
    );
    uint256 shipBattleId = abi.decode(shipBattleInitiateBattleReturnData, (uint256));

    shipBattleServiceAutoPlayTillEnd(shipBattleId, playerId);
  }

  function shipBattleServiceAutoPlayTillEnd(uint256 shipBattleId, uint256 playerId) public {
    IWorldContextConsumer ctx = IWorldContextConsumer(address(this));
    IBaseWorld world = IBaseWorld(ctx._world());
    ResourceId shipBattleSystemId = WorldResourceIdLib.encode({
      typeId: RESOURCE_SYSTEM,
      namespace: "app",
      name: "ShipBattleSystem"
    });

    for (uint256 i = 0; i < MAX_NUMBER_OF_ROUNDS; i++) {
      uint8 status = ShipBattle.getStatus(shipBattleId);
      if (status == BattleStatus.ENDED) {
        break;
      }

      // call shipBattleSystem.shipBattleMakeMove(shipBattleId, ShipBattleCommand.ATTACK);
      world.callFrom(
        ctx._msgSender(),
        shipBattleSystemId,
        abi.encodeCall(ShipBattleSystem.shipBattleMakeMove, (shipBattleId, ShipBattleCommand.ATTACK))
      );
    }
  }
}
