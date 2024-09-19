// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ShipProductionProcessStarted } from "./SkillProcessEvents.sol";
import { SkillProcessData, PlayerData, ItemProductionData } from "../codegen/index.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";
import { PlayerInventoryUpdateUtil } from "./PlayerInventoryUpdateUtil.sol";
import { SkillProcessUtil } from "../utils/SkillProcessUtil.sol";
import { SkillProcessId } from "../systems/SkillProcessId.sol";
import { SkillTypeItemIdPair } from "../systems/SkillTypeItemIdPair.sol";
import { ItemIds, SHIP } from "../utils/ItemIds.sol";
import { Player, ItemProduction } from "../codegen/index.sol";
import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";

error ProcessAlreadyStarted(uint32 currentItemId, bool completed);
error NotEnoughEnergy(uint256 required, uint256 available);
error LowerThanRequiredLevel(uint16 required, uint16 current);
error SenderHasNoPermission(address sender, address owner);
error ItemIdIsNotShip(uint32 itemId, uint32 expectedItemId);
error MaterialsMismatch(uint32 requiredItemId);
error NotEnoughMaterials(uint32 itemId, uint32 required, uint32 provided);
error ArrayLengthMismatch(uint256 requiredLength, uint256 actualLength);

library SkillProcessStartShipProductionLogic {
  uint32 constant SHIP_ITEM_ID = SHIP;

  function verify(
    uint8 skillType,
    uint256 playerId,
    uint8 sequenceNumber,
    uint32 itemId,
    ItemIdQuantityPair[] memory productionMaterials,
    SkillProcessData memory skillProcessData
  ) internal view returns (ShipProductionProcessStarted memory) {
    PlayerData memory playerData = Player.get(playerId);
    ItemProductionData memory itemProductionData = ItemProduction.get(skillType, itemId);

    if (WorldContextConsumerLib._msgSender() != playerData.owner) {
      revert SenderHasNoPermission(WorldContextConsumerLib._msgSender(), playerData.owner);
    }

    if (skillProcessData.itemId != ItemIds.unusedItem() && !skillProcessData.completed) {
      revert ProcessAlreadyStarted(skillProcessData.itemId, skillProcessData.completed);
    }

    SkillTypeItemIdPair memory itemProductionId = SkillTypeItemIdPair(skillType, itemId);
    SkillProcessId memory skillProcessId = SkillProcessId(skillType, playerId, sequenceNumber);

    (uint256 _playerId, uint8 _skillType, uint32 _itemId) = SkillProcessUtil
      .assertIdsAreConsistentForStartingProduction(playerId, itemProductionId, skillProcessId);

    if (_itemId != SHIP_ITEM_ID) {
      revert ItemIdIsNotShip(_itemId, SHIP_ITEM_ID);
    }

    if (playerData.level < itemProductionData.requirementsLevel) {
      revert LowerThanRequiredLevel(itemProductionData.requirementsLevel, playerData.level);
    }

    uint256 energyCost = itemProductionData.energyCost;
    // if (availableEnergy < energyCost) {
    //   revert NotEnoughEnergy(energyCost, availableEnergy);
    // }

    verifyProductionMaterials(
      productionMaterials,
      itemProductionData.materialItemIds,
      itemProductionData.materialItemQuantities
    );

    return
      ShipProductionProcessStarted({
        skillType: _skillType,
        playerId: _playerId,
        sequenceNumber: sequenceNumber,
        itemId: _itemId,
        energyCost: uint64(energyCost),
        startedAt: uint64(block.timestamp),
        creationTime: itemProductionData.baseCreationTime,
        productionMaterials: productionMaterials
      });
  }

  function mutate(
    ShipProductionProcessStarted memory shipProductionProcessStarted,
    SkillProcessData memory skillProcessData
  ) internal returns (SkillProcessData memory) {
    skillProcessData.itemId = shipProductionProcessStarted.itemId;
    skillProcessData.startedAt = shipProductionProcessStarted.startedAt;
    skillProcessData.creationTime = shipProductionProcessStarted.creationTime;
    skillProcessData.completed = false;
    skillProcessData.endedAt = 0;

    // TODO: Implement energy deduction
    // let energy_vault = skill_process::borrow_mut_energy_vault(skill_process);
    // balance::join(energy_vault, energy);

    PlayerInventoryUpdateUtil.subtractMultipleFromInventory(
      shipProductionProcessStarted.playerId,
      shipProductionProcessStarted.productionMaterials
    );

    return skillProcessData;
  }

  function verifyProductionMaterials(
    ItemIdQuantityPair[] memory actualMaterials,
    uint32[] memory requiredItemIds,
    uint32[] memory requiredQuantities
  ) private pure {
    if (requiredItemIds.length != requiredQuantities.length) {
      revert ArrayLengthMismatch(requiredItemIds.length, requiredQuantities.length);
    }

    for (uint i = 0; i < requiredItemIds.length; i++) {
      bool found = false;
      for (uint j = 0; j < actualMaterials.length; j++) {
        if (actualMaterials[j].itemId == requiredItemIds[i]) {
          if (actualMaterials[j].quantity < requiredQuantities[i]) {
            revert NotEnoughMaterials(requiredItemIds[i], requiredQuantities[i], actualMaterials[j].quantity);
          }
          found = true;
          break;
        }
      }
      if (!found) {
        revert MaterialsMismatch(requiredItemIds[i]);
      }
    }
  }
}
