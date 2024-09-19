// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { ResourceId, WorldResourceIdLib } from "@latticexyz/world/src/WorldResourceId.sol";
import { RESOURCE_SYSTEM } from "@latticexyz/world/src/worldResourceTypes.sol";
import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";
import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";

library PlayerDelegationLib {

  function create(string memory name) internal {
    ResourceId playerSystemId = WorldResourceIdLib.encode({
      typeId: RESOURCE_SYSTEM,
      namespace: "app",
      name: "PlayerSystem"
    });

    IBaseWorld world = IBaseWorld(WorldContextConsumerLib._world());
    world.callFrom(
      WorldContextConsumerLib._msgSender(),
      playerSystemId,
      abi.encodeWithSignature(
        "playerCreate(string)",
        name
      )
    );

  }

  function claimIsland(uint256 id, uint32 coordinatesX, uint32 coordinatesY) internal {
    ResourceId playerSystemId = WorldResourceIdLib.encode({
      typeId: RESOURCE_SYSTEM,
      namespace: "app",
      name: "PlayerSystem"
    });

    IBaseWorld world = IBaseWorld(WorldContextConsumerLib._world());
    world.callFrom(
      WorldContextConsumerLib._msgSender(),
      playerSystemId,
      abi.encodeWithSignature(
        "playerClaimIsland(uint256,uint32,uint32)",
        id, coordinatesX, coordinatesY
      )
    );

  }

  function airdrop(uint256 id, uint32 itemId, uint32 quantity) internal {
    ResourceId playerSystemId = WorldResourceIdLib.encode({
      typeId: RESOURCE_SYSTEM,
      namespace: "app",
      name: "PlayerSystem"
    });

    IBaseWorld world = IBaseWorld(WorldContextConsumerLib._world());
    world.callFrom(
      WorldContextConsumerLib._msgSender(),
      playerSystemId,
      abi.encodeWithSignature(
        "playerAirdrop(uint256,uint32,uint32)",
        id, itemId, quantity
      )
    );

  }

  function gatherIslandResources(uint256 id) internal {
    ResourceId playerSystemId = WorldResourceIdLib.encode({
      typeId: RESOURCE_SYSTEM,
      namespace: "app",
      name: "PlayerSystem"
    });

    IBaseWorld world = IBaseWorld(WorldContextConsumerLib._world());
    world.callFrom(
      WorldContextConsumerLib._msgSender(),
      playerSystemId,
      abi.encodeWithSignature(
        "playerGatherIslandResources(uint256)",
        id
      )
    );

  }

  function deductItems(uint256 id, ItemIdQuantityPair[] memory items) internal {
    ResourceId playerFriendSystemId = WorldResourceIdLib.encode({
      typeId: RESOURCE_SYSTEM,
      namespace: "app",
      name: "PlayerFriendSyst" // NOTE: Only the first 16 characters are used. Original: "PlayerFriendSystem"
    });

    IBaseWorld world = IBaseWorld(WorldContextConsumerLib._world());
    world.callFrom(
      WorldContextConsumerLib._msgSender(),
      playerFriendSystemId,
      abi.encodeWithSignature(
        "playerDeductItems(uint256,(uint32,uint32)[])",
        id, items
      )
    );

  }

  function increaseExperienceAndItems(uint256 id, uint32 experienceGained, ItemIdQuantityPair[] memory items, uint16 newLevel) internal {
    ResourceId playerFriendSystemId = WorldResourceIdLib.encode({
      typeId: RESOURCE_SYSTEM,
      namespace: "app",
      name: "PlayerFriendSyst" // NOTE: Only the first 16 characters are used. Original: "PlayerFriendSystem"
    });

    IBaseWorld world = IBaseWorld(WorldContextConsumerLib._world());
    world.callFrom(
      WorldContextConsumerLib._msgSender(),
      playerFriendSystemId,
      abi.encodeWithSignature(
        "playerIncreaseExperienceAndItems(uint256,uint32,(uint32,uint32)[],uint16)",
        id, experienceGained, items, newLevel
      )
    );

  }

}