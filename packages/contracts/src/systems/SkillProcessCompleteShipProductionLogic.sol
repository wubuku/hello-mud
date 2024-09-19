// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ShipProductionProcessCompleted } from "./SkillProcessEvents.sol";
import { SkillProcessData, PlayerData, ItemProductionData } from "../codegen/index.sol";
import { SkillProcessUtil } from "../utils/SkillProcessUtil.sol";
import { ItemIds } from "../utils/ItemIds.sol";
import { Player, ItemProduction } from "../codegen/index.sol";
import { ExperienceTableUtil } from "../utils/ExperienceTableUtil.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";
import { PlayerDelegationLib } from "../systems/PlayerDelegationLib.sol";
import { SkillTypeItemIdPair } from "./SkillTypeItemIdPair.sol";
import { SkillProcessId } from "./SkillProcessId.sol";

error ProcessNotStarted(uint32 itemId, bool completed);
error ItemIdIsNotShip(uint32 itemId);
error RosterIsNotUnassignedShips(uint8 sequenceNumber);
error InvalidRosterPlayerId(uint256 playerId, uint256 rosterId);
error BuildingExpensesNotSet();
error StillInProgress(uint64 currentTime, uint64 expectedCompletionTime);

library SkillProcessCompleteShipProductionLogic {
  function verify(
    uint8 skillType,
    uint256 playerId,
    uint8 sequenceNumber,
    SkillProcessData memory skillProcessData
  ) internal view returns (ShipProductionProcessCompleted memory) {
    PlayerData memory playerData = Player.get(playerId);
    ItemProductionData memory itemProductionData = ItemProduction.get(skillType, skillProcessData.itemId);

    // TODO: Implement how to get unassignedShips data
    uint256 unassignedShipsId;

    (uint256 _playerId, uint8 _skillType, uint32 itemId) = SkillProcessUtil
      .assertIdsAreConsistentForCompletingProduction(
        playerId,
        SkillTypeItemIdPair(skillType, skillProcessData.itemId),
        SkillProcessId(skillType, playerId, sequenceNumber),
        skillProcessData
      );

    if (itemId == ItemIds.unusedItem() || skillProcessData.completed) {
      revert ProcessNotStarted(itemId, skillProcessData.completed);
    }

    if (itemId != ItemIds.ship()) {
      revert ItemIdIsNotShip(itemId);
    }

    uint64 endedAt = uint64(block.timestamp);
    if (endedAt < skillProcessData.startedAt + skillProcessData.creationTime) {
      revert StillInProgress(endedAt, skillProcessData.startedAt + skillProcessData.creationTime);
    }

    bool successful = true; // TODO: Always successful for now
    uint32 quantity = itemProductionData.baseQuantity;
    uint32 increasedExperience = itemProductionData.baseExperience;

    uint16 newLevel = ExperienceTableUtil.calculateNewLevel(
      playerData.level,
      playerData.experience,
      increasedExperience
    );

    return
      ShipProductionProcessCompleted({
        skillType: _skillType,
        playerId: _playerId,
        sequenceNumber: sequenceNumber,
        itemId: itemId,
        startedAt: skillProcessData.startedAt,
        creationTime: skillProcessData.creationTime,
        endedAt: endedAt,
        successful: successful,
        quantity: quantity,
        experienceGained: increasedExperience,
        newLevel: newLevel
      });
  }

  function mutate(
    ShipProductionProcessCompleted memory shipProductionProcessCompleted,
    SkillProcessData memory skillProcessData
  ) internal returns (SkillProcessData memory) {
    skillProcessData.completed = true;
    skillProcessData.endedAt = shipProductionProcessCompleted.endedAt;

    if (!shipProductionProcessCompleted.successful) {
      // TODO: Not implemented yet
      return skillProcessData;
    }
    // RosterData memory unassignedShips = Roster.get(unassignedShipsId);
    // TODO: Implement checks for unassignedShips
    // if (unassignedShips.sequenceNumber != ItemIds.unassignedShips()) {
    //   revert RosterIsNotUnassignedShips(unassignedShips.sequenceNumber);
    // }
    // if (playerId != unassignedShips.playerId) {
    //   revert InvalidRosterPlayerId(playerId, unassignedShips.playerId);
    // }
    // if (skillProcessData.productionMaterials.length == 0) {
    //   revert BuildingExpensesNotSet();
    // }

    // TODO: Implement ship creation and addition to unassigned ships roster
    // (uint32 healthPoints, uint32 attack, uint32 protection, uint32 speed) = ShipUtil.calculateShipAttributes(skillProcessData.productionMaterials);
    // uint256 shipId = ShipAggregate.create(
    //   shipProductionProcessCompleted.playerId,
    //   healthPoints,
    //   attack,
    //   protection,
    //   speed,
    //   skillProcessData.productionMaterials
    // );
    // RosterAggregate.addShip(unassignedShipsId, shipId);

    ItemIdQuantityPair[] memory items = new ItemIdQuantityPair[](0);
    PlayerDelegationLib.increaseExperienceAndItems(
      shipProductionProcessCompleted.playerId,
      shipProductionProcessCompleted.experienceGained,
      items,
      shipProductionProcessCompleted.newLevel
    );

    return skillProcessData;
  }
}
