// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { ResourceId, WorldResourceIdLib } from "@latticexyz/world/src/WorldResourceId.sol";
import { RESOURCE_SYSTEM } from "@latticexyz/world/src/worldResourceTypes.sol";
import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";
import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";
import { WorldContextProviderLib } from "@latticexyz/world/src/WorldContext.sol";
import { revertWithBytes } from "@latticexyz/world/src/revertWithBytes.sol";
import { Systems } from "@latticexyz/world/src/codegen/tables/Systems.sol";
import { ShipBattleLocationParams } from "./ShipBattleLocationParams.sol";

library ShipBattleDelegatecallLib {

  function initiateBattle(uint256 playerId, uint256 initiatorRosterPlayerId, uint32 initiatorRosterSequenceNumber, uint256 responderRosterPlayerId, uint32 responderRosterSequenceNumber, ShipBattleLocationParams memory updateLocationParams) internal returns (uint256) {
    ResourceId shipBattleInitiateSystemId = WorldResourceIdLib.encode({
      typeId: RESOURCE_SYSTEM,
      namespace: "app",
      name: "ShipBattleInitia" // NOTE: Only the first 16 characters are used. Original: "ShipBattleInitiateSystem"
    });

    (address shipBattleInitiateSystemAddress, ) = Systems.get(shipBattleInitiateSystemId);
    (bool success, bytes memory returnData) = WorldContextProviderLib.delegatecallWithContext(
      WorldContextConsumerLib._msgSender(),
      0,
      shipBattleInitiateSystemAddress,
      abi.encodeWithSignature(
        "initiateShipBattle(uint256,uint256,uint32,uint256,uint32,((uint32,uint32),uint16,(uint32,uint32),uint16,uint64))",
        playerId, initiatorRosterPlayerId, initiatorRosterSequenceNumber, responderRosterPlayerId, responderRosterSequenceNumber, updateLocationParams
      )
    );
    if (!success) revertWithBytes(returnData);

    return abi.decode(returnData, (uint256));
  }

  function makeMove(uint256 id, uint8 attackerCommand) internal {
    ResourceId shipBattleSystemId = WorldResourceIdLib.encode({
      typeId: RESOURCE_SYSTEM,
      namespace: "app",
      name: "ShipBattleSystem"
    });

    (address shipBattleSystemAddress, ) = Systems.get(shipBattleSystemId);
    (bool success, bytes memory returnData) = WorldContextProviderLib.delegatecallWithContext(
      WorldContextConsumerLib._msgSender(),
      0,
      shipBattleSystemAddress,
      abi.encodeWithSignature(
        "shipBattleMakeMove(uint256,uint8)",
        id, attackerCommand
      )
    );
    if (!success) revertWithBytes(returnData);

  }

  function takeLoot(uint256 id, uint8 choice) internal {
    ResourceId shipBattleTakeLootSystemId = WorldResourceIdLib.encode({
      typeId: RESOURCE_SYSTEM,
      namespace: "app",
      name: "ShipBattleTakeLo" // NOTE: Only the first 16 characters are used. Original: "ShipBattleTakeLootSystem"
    });

    (address shipBattleTakeLootSystemAddress, ) = Systems.get(shipBattleTakeLootSystemId);
    (bool success, bytes memory returnData) = WorldContextProviderLib.delegatecallWithContext(
      WorldContextConsumerLib._msgSender(),
      0,
      shipBattleTakeLootSystemAddress,
      abi.encodeWithSignature(
        "shipBattleTakeLoot(uint256,uint8)",
        id, choice
      )
    );
    if (!success) revertWithBytes(returnData);

  }

}
