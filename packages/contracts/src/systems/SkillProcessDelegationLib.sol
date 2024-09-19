// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { ResourceId, WorldResourceIdLib } from "@latticexyz/world/src/WorldResourceId.sol";
import { RESOURCE_SYSTEM } from "@latticexyz/world/src/worldResourceTypes.sol";
import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";
import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";

library SkillProcessDelegationLib {

  function create(uint8 skillType, uint256 playerId, uint8 sequenceNumber) internal {
    ResourceId skillProcessFriendSystemId = WorldResourceIdLib.encode({
      typeId: RESOURCE_SYSTEM,
      namespace: "app",
      name: "SkillProcessFrie" // NOTE: Only the first 16 characters are used. Original: "SkillProcessFriendSystem"
    });

    IBaseWorld world = IBaseWorld(WorldContextConsumerLib._world());
    world.callFrom(
      WorldContextConsumerLib._msgSender(),
      skillProcessFriendSystemId,
      abi.encodeWithSignature(
        "skillProcessCreate(uint8,uint256,uint8)",
        skillType, playerId, sequenceNumber
      )
    );

  }

  function startProduction(uint8 skillType, uint256 playerId, uint8 sequenceNumber, uint32 itemId, uint32 batchSize) internal {
    ResourceId skillProcessFriendSystemId = WorldResourceIdLib.encode({
      typeId: RESOURCE_SYSTEM,
      namespace: "app",
      name: "SkillProcessFrie" // NOTE: Only the first 16 characters are used. Original: "SkillProcessFriendSystem"
    });

    IBaseWorld world = IBaseWorld(WorldContextConsumerLib._world());
    world.callFrom(
      WorldContextConsumerLib._msgSender(),
      skillProcessFriendSystemId,
      abi.encodeWithSignature(
        "skillProcessStartProduction(uint8,uint256,uint8,uint32,uint32)",
        skillType, playerId, sequenceNumber, itemId, batchSize
      )
    );

  }

  function completeProduction(uint8 skillType, uint256 playerId, uint8 sequenceNumber) internal {
    ResourceId skillProcessSystemId = WorldResourceIdLib.encode({
      typeId: RESOURCE_SYSTEM,
      namespace: "app",
      name: "SkillProcessSyst" // NOTE: Only the first 16 characters are used. Original: "SkillProcessSystem"
    });

    IBaseWorld world = IBaseWorld(WorldContextConsumerLib._world());
    world.callFrom(
      WorldContextConsumerLib._msgSender(),
      skillProcessSystemId,
      abi.encodeWithSignature(
        "skillProcessCompleteProduction(uint8,uint256,uint8)",
        skillType, playerId, sequenceNumber
      )
    );

  }

  function startShipProduction(uint8 skillType, uint256 playerId, uint8 sequenceNumber, ItemIdQuantityPair[] memory productionMaterials, uint32 itemId) internal {
    ResourceId skillProcessFriendSystemId = WorldResourceIdLib.encode({
      typeId: RESOURCE_SYSTEM,
      namespace: "app",
      name: "SkillProcessFrie" // NOTE: Only the first 16 characters are used. Original: "SkillProcessFriendSystem"
    });

    IBaseWorld world = IBaseWorld(WorldContextConsumerLib._world());
    world.callFrom(
      WorldContextConsumerLib._msgSender(),
      skillProcessFriendSystemId,
      abi.encodeWithSignature(
        "skillProcessStartShipProduction(uint8,uint256,uint8,(uint32,uint32)[],uint32)",
        skillType, playerId, sequenceNumber, productionMaterials, itemId
      )
    );

  }

  function completeShipProduction(uint8 skillType, uint256 playerId, uint8 sequenceNumber) internal {
    ResourceId skillProcessSystemId = WorldResourceIdLib.encode({
      typeId: RESOURCE_SYSTEM,
      namespace: "app",
      name: "SkillProcessSyst" // NOTE: Only the first 16 characters are used. Original: "SkillProcessSystem"
    });

    IBaseWorld world = IBaseWorld(WorldContextConsumerLib._world());
    world.callFrom(
      WorldContextConsumerLib._msgSender(),
      skillProcessSystemId,
      abi.encodeWithSignature(
        "skillProcessCompleteShipProduction(uint8,uint256,uint8)",
        skillType, playerId, sequenceNumber
      )
    );

  }

  function startCreation(uint8 skillType, uint256 playerId, uint8 sequenceNumber, uint32 itemId, uint32 batchSize) internal {
    ResourceId skillProcessFriendSystemId = WorldResourceIdLib.encode({
      typeId: RESOURCE_SYSTEM,
      namespace: "app",
      name: "SkillProcessFrie" // NOTE: Only the first 16 characters are used. Original: "SkillProcessFriendSystem"
    });

    IBaseWorld world = IBaseWorld(WorldContextConsumerLib._world());
    world.callFrom(
      WorldContextConsumerLib._msgSender(),
      skillProcessFriendSystemId,
      abi.encodeWithSignature(
        "skillProcessStartCreation(uint8,uint256,uint8,uint32,uint32)",
        skillType, playerId, sequenceNumber, itemId, batchSize
      )
    );

  }

  function completeCreation(uint8 skillType, uint256 playerId, uint8 sequenceNumber) internal {
    ResourceId skillProcessSystemId = WorldResourceIdLib.encode({
      typeId: RESOURCE_SYSTEM,
      namespace: "app",
      name: "SkillProcessSyst" // NOTE: Only the first 16 characters are used. Original: "SkillProcessSystem"
    });

    IBaseWorld world = IBaseWorld(WorldContextConsumerLib._world());
    world.callFrom(
      WorldContextConsumerLib._msgSender(),
      skillProcessSystemId,
      abi.encodeWithSignature(
        "skillProcessCompleteCreation(uint8,uint256,uint8)",
        skillType, playerId, sequenceNumber
      )
    );

  }

}
