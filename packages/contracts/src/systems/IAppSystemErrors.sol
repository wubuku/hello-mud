// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

interface IAppSystemErrors {
  error RequireNamespaceOwner(address caller, address requiredOwner);

  error PositionAlreadyExists(address player);
  error PositionDoesNotExist(address player);

  error TerrainAlreadyExists(uint32 x, uint32 y);
  error TerrainDoesNotExist(uint32 x, uint32 y);

  error ArticleAlreadyExists(uint64 id);
  error ArticleDoesNotExist(uint64 id);

  error AccountPlayerAlreadyExists(address accountAddress);
  error AccountPlayerDoesNotExist(address accountAddress);

  error PlayerAlreadyExists(uint256 id);
  error PlayerDoesNotExist(uint256 id);

  error ShipAlreadyExists(uint256 id);
  error ShipDoesNotExist(uint256 id);

  error RosterAlreadyExists(uint256 playerId, uint32 sequenceNumber);
  error RosterDoesNotExist(uint256 playerId, uint32 sequenceNumber);

  error ShipBattleAlreadyExists(uint256 id);
  error ShipBattleDoesNotExist(uint256 id);

  error ItemAlreadyExists(uint32 itemId);
  error ItemDoesNotExist(uint32 itemId);

  error ItemCreationAlreadyExists(uint8 itemCreationIdSkillType, uint32 itemCreationIdItemId);
  error ItemCreationDoesNotExist(uint8 itemCreationIdSkillType, uint32 itemCreationIdItemId);

  error ItemProductionAlreadyExists(uint8 itemProductionIdSkillType, uint32 itemProductionIdItemId);
  error ItemProductionDoesNotExist(uint8 itemProductionIdSkillType, uint32 itemProductionIdItemId);

  error SkillProcessAlreadyExists(uint8 skillProcessIdSkillType, uint256 skillProcessIdPlayerId, uint8 skillProcessIdSequenceNumber);
  error SkillProcessDoesNotExist(uint8 skillProcessIdSkillType, uint256 skillProcessIdPlayerId, uint8 skillProcessIdSequenceNumber);

  error EnergyDropAlreadyExists(address accountAddress);
  error EnergyDropDoesNotExist(address accountAddress);

  error IslandClaimWhitelistAlreadyExists(address accountAddress);
  error IslandClaimWhitelistDoesNotExist(address accountAddress);

  error ShipItemAlreadyExists(uint32 itemId);
  error ShipItemDoesNotExist(uint32 itemId);

  error IslandRenewableItemAlreadyExists(uint32 itemId);
  error IslandRenewableItemDoesNotExist(uint32 itemId);

  error ItemToShipAttributesAlreadyExists(uint32 itemId);
  error ItemToShipAttributesDoesNotExist(uint32 itemId);

  error ShipItemMountingPositionAlreadyExists(uint32 shipItemMountingPositionIdItemId, uint8 shipItemMountingPositionIdMountingPosition);
  error ShipItemMountingPositionDoesNotExist(uint32 shipItemMountingPositionIdItemId, uint8 shipItemMountingPositionIdMountingPosition);

  error ShipMountingAlreadyExists(uint256 shipIdMountingPositionPairShipId, uint8 shipIdMountingPositionPairMountingPosition);
  error ShipMountingDoesNotExist(uint256 shipIdMountingPositionPairShipId, uint8 shipIdMountingPositionPairMountingPosition);

  error CounterAlreadyExists();
  error CounterDoesNotExist();

  error MapAlreadyExists();
  error MapDoesNotExist();

  error ExperienceTableAlreadyExists();
  error ExperienceTableDoesNotExist();

  error EnergyTokenAlreadyExists();
  error EnergyTokenDoesNotExist();

}
