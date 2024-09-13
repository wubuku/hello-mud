// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ResourceId, WorldResourceIdLib } from "@latticexyz/world/src/WorldResourceId.sol";
import { RESOURCE_SYSTEM } from "@latticexyz/world/src/worldResourceTypes.sol";
import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";
import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";

library ShipBattleDelegationLib {

  function initiateBattle(uint256 playerId, uint256 initiatorRosterPlayerId, uint32 initiatorRosterSequenceNumber, uint256 responderRosterPlayerId, uint32 responderRosterSequenceNumber, int32 initiatorCoordinatesX, int32 initiatorCoordinatesY, int32 responderCoordinatesX, int32 responderCoordinatesY) internal returns (uint256) {
    ResourceId shipBattleSystemId = WorldResourceIdLib.encode({
      typeId: RESOURCE_SYSTEM,
      namespace: "app",
      name: "ShipBattleSystem"
    });

    IBaseWorld world = IBaseWorld(WorldContextConsumerLib._world());
    address msgSender = WorldContextConsumerLib._msgSender();

    bytes memory returnData = world.callFrom(
      msgSender,
      shipBattleSystemId,
      abi.encodeWithSignature(
        "shipBattleInitiateBattle(uint256,uint256,uint32,uint256,uint32,int32,int32,int32,int32)",
        playerId, initiatorRosterPlayerId, initiatorRosterSequenceNumber, responderRosterPlayerId, responderRosterSequenceNumber, initiatorCoordinatesX, initiatorCoordinatesY, responderCoordinatesX, responderCoordinatesY
      )
    );

    return abi.decode(returnData, (uint256));
  }

}
