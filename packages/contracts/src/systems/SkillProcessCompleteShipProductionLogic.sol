// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ShipProductionProcessCompleted } from "./SkillProcessEvents.sol";
import { SkillProcessData, SkillPrcMtrlData, PlayerData, ItemProductionData, RosterData, Roster } from "../codegen/index.sol";
import { SkillProcessUtil } from "../utils/SkillProcessUtil.sol";
import { ItemIds } from "../utils/ItemIds.sol";
import { Player, ItemProduction } from "../codegen/index.sol";
import { ExperienceTableUtil } from "../utils/ExperienceTableUtil.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";
import { PlayerDelegationLib } from "../systems/PlayerDelegationLib.sol";
import { SkillTypeItemIdPair } from "./SkillTypeItemIdPair.sol";
import { SkillProcessId } from "./SkillProcessId.sol";
import { RosterSequenceNumber } from "./RosterSequenceNumber.sol";
import { ShipUtil } from "../utils/ShipUtil.sol";
import { ShipDelegationLib } from "./ShipDelegationLib.sol";
import { SkillPrcMtrlLib } from "./SkillPrcMtrlLib.sol";
import { RosterUtil } from "../utils/RosterUtil.sol";

error ProcessNotStarted(uint32 itemId, bool completed);
error ItemIdIsNotShip(uint32 itemId);
error RosterUnassignedShipsNotFound(uint256 playerId);
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
    uint256 playerId = shipProductionProcessCompleted.playerId;
    RosterData memory unassignedShips = Roster.get(playerId, RosterSequenceNumber.UNASSIGNED_SHIPS);
    // TODO if (!unassignedShips.getExisting()) {
    //   revert RosterUnassignedShipsNotFound(playerId);
    // }

    // 使用 SkillPrcMtrlLib 获取生产材料
    SkillPrcMtrlData[] memory productionMaterials = SkillPrcMtrlLib.getAllProductionMaterials(
      shipProductionProcessCompleted.skillType,
      shipProductionProcessCompleted.playerId,
      shipProductionProcessCompleted.sequenceNumber
    );

    // 填充 buildingExpenses, buildingExpensesItemIds, 和 buildingExpensesQuantities
    ItemIdQuantityPair[] memory buildingExpenses = new ItemIdQuantityPair[](productionMaterials.length);
    uint32[] memory buildingExpensesItemIds = new uint32[](productionMaterials.length);
    uint32[] memory buildingExpensesQuantities = new uint32[](productionMaterials.length);

    for (uint i = 0; i < productionMaterials.length; i++) {
      buildingExpenses[i] = ItemIdQuantityPair(
        productionMaterials[i].productionMaterialItemId,
        productionMaterials[i].productionMaterialQuantity
      );
      buildingExpensesItemIds[i] = productionMaterials[i].productionMaterialItemId;
      buildingExpensesQuantities[i] = productionMaterials[i].productionMaterialQuantity;
    }

    (uint32 healthPoints, uint32 attack, uint32 protection, uint32 speed) = ShipUtil.calculateShipAttributes(
      buildingExpenses
    );
    uint256 shipId = ShipDelegationLib.create(
      playerId,
      RosterSequenceNumber.UNASSIGNED_SHIPS,
      healthPoints,
      attack,
      protection,
      speed,
      buildingExpensesItemIds,
      buildingExpensesQuantities
    );

    // Add created ship addition to unassigned ships roster
    uint256[] memory shipIds = unassignedShips.shipIds;
    shipIds = RosterUtil.addShipIdToEnd(shipIds, shipId);
    unassignedShips.shipIds = shipIds;

    ItemIdQuantityPair[] memory emptyItems = new ItemIdQuantityPair[](0);
    PlayerDelegationLib.increaseExperienceAndItems(
      shipProductionProcessCompleted.playerId,
      shipProductionProcessCompleted.experienceGained,
      emptyItems,
      shipProductionProcessCompleted.newLevel
    );

    return skillProcessData;
  }
}
