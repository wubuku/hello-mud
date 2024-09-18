// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { ResourceId, WorldResourceIdLib } from "@latticexyz/world/src/WorldResourceId.sol";
import { RESOURCE_SYSTEM } from "@latticexyz/world/src/worldResourceTypes.sol";
import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";
import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";

library ShipDelegationLib {

  function create(uint256 rosterIdPlayerId, uint32 rosterIdSequenceNumber, uint32 healthPoints, uint32 attack, uint32 protection, uint32 speed, uint32[] memory buildingExpensesItemIds, uint32[] memory buildingExpensesQuantities) internal returns (uint256) {
    ResourceId shipSystemId = WorldResourceIdLib.encode({
      typeId: RESOURCE_SYSTEM,
      namespace: "app",
      name: "ShipSystem"
    });

    IBaseWorld world = IBaseWorld(WorldContextConsumerLib._world());
    bytes memory returnData = world.callFrom(
      WorldContextConsumerLib._msgSender(),
      shipSystemId,
      abi.encodeWithSignature(
        "shipCreate(uint256,uint32,uint32,uint32,uint32,uint32,uint32[],uint32[])",
        rosterIdPlayerId, rosterIdSequenceNumber, healthPoints, attack, protection, speed, buildingExpensesItemIds, buildingExpensesQuantities
      )
    );

    return abi.decode(returnData, (uint256));
  }

}
