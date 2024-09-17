// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";

struct ProductionProcessStarted {
  uint8 skillType;
  uint256 playerId;
  uint8 sequenceNumber;
  uint32 batchSize;
  uint32 itemId;
  uint64 energyCost;
  uint64 startedAt;
  uint64 creationTime;
  ItemIdQuantityPair[] productionMaterials;
}

struct ProductionProcessCompleted {
  uint8 skillType;
  uint256 playerId;
  uint8 sequenceNumber;
  uint32 itemId;
  uint64 startedAt;
  uint64 creationTime;
  uint64 endedAt;
  bool successful;
  uint32 quantity;
  uint32 experience;
  uint16 newLevel;
}

struct ShipProductionProcessStarted {
  uint8 skillType;
  uint256 playerId;
  uint8 sequenceNumber;
  uint32 itemId;
  uint64 energyCost;
  uint64 startedAt;
  uint64 creationTime;
  ItemIdQuantityPair[] productionMaterials;
}

struct ShipProductionProcessCompleted {
  uint8 skillType;
  uint256 playerId;
  uint8 sequenceNumber;
  uint32 itemId;
  uint64 startedAt;
  uint64 creationTime;
  uint64 endedAt;
  bool successful;
  uint32 quantity;
  uint32 experience;
  uint16 newLevel;
}

struct CreationProcessStarted {
  uint8 skillType;
  uint256 playerId;
  uint8 sequenceNumber;
  uint32 batchSize;
  uint32 itemId;
  uint64 energyCost;
  uint32 resourceCost;
  uint64 startedAt;
  uint64 creationTime;
}

struct CreationProcessCompleted {
  uint8 skillType;
  uint256 playerId;
  uint8 sequenceNumber;
  uint32 itemId;
  uint64 startedAt;
  uint64 creationTime;
  uint64 endedAt;
  bool successful;
  uint32 quantity;
  uint32 experience;
  uint16 newLevel;
}

struct SkillProcessCreated {
  uint8 skillType;
  uint256 playerId;
  uint8 sequenceNumber;
  uint32 itemId;
  uint64 startedAt;
  uint64 creationTime;
  bool completed;
  uint64 endedAt;
  uint32 batchSize;
}

