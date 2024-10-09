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
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";

library PlayerDelegatecallLib {

  function deductItems(uint256 id, ItemIdQuantityPair[] memory items) internal {
    ResourceId playerFriendSystemId = WorldResourceIdLib.encode({
      typeId: RESOURCE_SYSTEM,
      namespace: "app",
      name: "PlayerFriendSyst" // NOTE: Only the first 16 characters are used. Original: "PlayerFriendSystem"
    });

    (address playerFriendSystemAddress, ) = Systems.get(playerFriendSystemId);
    (bool success, bytes memory returnData) = WorldContextProviderLib.delegatecallWithContext(
      WorldContextConsumerLib._msgSender(),
      0,
      playerFriendSystemAddress,
      abi.encodeWithSignature(
        "playerDeductItems(uint256,(uint32,uint32)[])",
        id, items
      )
    );
    if (!success) revertWithBytes(returnData);

  }

  function increaseExperienceAndItems(uint256 id, uint32 experienceGained, ItemIdQuantityPair[] memory items, uint16 newLevel) internal {
    ResourceId playerFriendSystemId = WorldResourceIdLib.encode({
      typeId: RESOURCE_SYSTEM,
      namespace: "app",
      name: "PlayerFriendSyst" // NOTE: Only the first 16 characters are used. Original: "PlayerFriendSystem"
    });

    (address playerFriendSystemAddress, ) = Systems.get(playerFriendSystemId);
    (bool success, bytes memory returnData) = WorldContextProviderLib.delegatecallWithContext(
      WorldContextConsumerLib._msgSender(),
      0,
      playerFriendSystemAddress,
      abi.encodeWithSignature(
        "playerIncreaseExperienceAndItems(uint256,uint32,(uint32,uint32)[],uint16)",
        id, experienceGained, items, newLevel
      )
    );
    if (!success) revertWithBytes(returnData);

  }

}
