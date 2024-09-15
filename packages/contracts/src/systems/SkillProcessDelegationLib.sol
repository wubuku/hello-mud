// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { ResourceId, WorldResourceIdLib } from "@latticexyz/world/src/WorldResourceId.sol";
import { RESOURCE_SYSTEM } from "@latticexyz/world/src/worldResourceTypes.sol";
import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";
import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";

library SkillProcessDelegationLib {

  function startProduction(uint8 skillType, uint256 playerId, uint8 sequenceNumber, uint32 batchSize, uint32 itemId) internal {
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
        "skillProcessStartProduction(uint8,uint256,uint8,uint32,uint32)",
        skillType, playerId, sequenceNumber, batchSize, itemId
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

  function startCreation(uint8 skillType, uint256 playerId, uint8 sequenceNumber, uint32 batchSize, uint32 itemId) internal {
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
        "skillProcessStartCreation(uint8,uint256,uint8,uint32,uint32)",
        skillType, playerId, sequenceNumber, batchSize, itemId
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

  function create(uint8 skillType, uint256 playerId, uint8 sequenceNumber, uint32 itemId, uint64 startedAt, uint64 creationTime, bool completed, uint64 endedAt, uint32 batchSize) internal {
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
        "skillProcessCreate(uint8,uint256,uint8,uint32,uint64,uint64,bool,uint64,uint32)",
        skillType, playerId, sequenceNumber, itemId, startedAt, creationTime, completed, endedAt, batchSize
      )
    );

  }

}