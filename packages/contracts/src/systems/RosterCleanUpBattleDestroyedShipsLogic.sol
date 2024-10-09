// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { RosterBattleDestroyedShipsCleanedUp } from "./RosterEvents.sol";
import { RosterData, Roster, ShipData, Ship } from "../codegen/index.sol";
import { RosterCleanUpBattleResult } from "./RosterCleanUpBattleResult.sol";
import { RosterId } from "./RosterId.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";
import { SortedVectorUtil } from "../utils/SortedVectorUtil.sol";
import { LootUtil } from "../utils/LootUtil.sol";
import { ShipIdUtil } from "../utils/ShipIdUtil.sol";
import { RosterDataInstance } from "../utils/RosterDataInstance.sol";

/**
 * @title RosterCleanUpBattleDestroyedShipsLogic Library
 * @dev Implements the Roster.CleanUpBattleDestroyedShips method.
 */
library RosterCleanUpBattleDestroyedShipsLogic {
  uint8 constant CHOICE_TAKE_ALL = 1;
  uint8 constant CHOICE_LEAVE_IT = 2; // NOTE: DON'T use 0, because it's the default value in Solidity
  uint64 constant LOOT_TAKING_TIME_LIMIT = 30; // 30 seconds

  using RosterDataInstance for RosterData;

  /**
   * @notice Verifies the Roster.CleanUpBattleDestroyedShips command.
   * @param rosterData The current state the Roster.
   * @return A RosterBattleDestroyedShipsCleanedUp event struct.
   */
  function verify(
    uint256 playerId,
    uint32 sequenceNumber,
    uint256 loserRosterIdPlayerId,
    uint32 loserRosterIdSequenceNumber,
    uint8 choice,
    RosterData memory rosterData
  ) internal pure returns (RosterBattleDestroyedShipsCleanedUp memory) {
    return
      RosterBattleDestroyedShipsCleanedUp(
        playerId,
        sequenceNumber,
        loserRosterIdPlayerId,
        loserRosterIdSequenceNumber,
        choice
      );
  }

  /**
   * @notice Performs the state mutation operation of Roster.CleanUpBattleDestroyedShips method.
   * @dev This function is called after verification to update the Roster's state.
   * @param cleanUpBattleDestroyedShipsEvent The RosterBattleDestroyedShipsCleanedUp event struct from the verify function.
   * @param rosterData The current state of the Roster.
   * @return The new state of the Roster.
   */
  function mutate(
    RosterBattleDestroyedShipsCleanedUp memory cleanUpBattleDestroyedShipsEvent,
    RosterData memory rosterData
  ) internal returns (RosterCleanUpBattleResult memory, RosterData memory) {
    RosterId memory winnerRosterId = RosterId(
      cleanUpBattleDestroyedShipsEvent.playerId,
      cleanUpBattleDestroyedShipsEvent.sequenceNumber
    );
    RosterId memory loserRosterId = RosterId(
      cleanUpBattleDestroyedShipsEvent.loserRosterIdPlayerId,
      cleanUpBattleDestroyedShipsEvent.loserRosterIdSequenceNumber
    );
    RosterData memory winnerRoster = Roster.get(winnerRosterId.playerId, winnerRosterId.sequenceNumber);
    RosterData memory loserRoster = Roster.get(loserRosterId.playerId, loserRosterId.sequenceNumber);

    (uint256[] memory loserDestroyedShipIds, ItemIdQuantityPair[] memory loot) = removeLooserShipsAndCalculateLoot(
      loserRoster,
      cleanUpBattleDestroyedShipsEvent.choice
    );

    (uint256[] memory winnerRemainingShipIds, uint32 newSpeed) = removeDestroyedWinnerShips(winnerRoster);

    RosterCleanUpBattleResult memory result;
    result.loot = loot;
    result.winnerRemainingShipIds = winnerRemainingShipIds;
    result.winnerNewSpeed = newSpeed;
    result.loserDestroyedShipIds = loserDestroyedShipIds;
    return (result, rosterData);
  }

  function removeLooserShipsAndCalculateLoot(
    RosterData memory loserRoster,
    uint8 choice
  ) internal returns (uint256[] memory, ItemIdQuantityPair[] memory) {
    uint256[] memory remainingShipIds = new uint256[](0);
    ItemIdQuantityPair[] memory loot = new ItemIdQuantityPair[](0);

    for (uint i = 0; i < loserRoster.shipIds.length; i++) {
      ShipData memory ship = Ship.get(loserRoster.shipIds[i]);
      if (choice != CHOICE_LEAVE_IT) {
        (uint32[] memory itemIds, uint32[] memory itemQuantities) = LootUtil.calculateLoot(
          loserRoster.shipIds[i],
          ship
        );
        ItemIdQuantityPair[] memory shipLoot = SortedVectorUtil.newItemIdQuantityPairs(itemIds, itemQuantities);
        loot = SortedVectorUtil.mergeItemIdQuantityPairs(loot, shipLoot);
      }
      Ship.deleteRecord(loserRoster.shipIds[i]);
    }

    return (remainingShipIds, loot);
  }

  function removeDestroyedWinnerShips(RosterData memory winnerRoster) internal returns (uint256[] memory, uint32) {
    uint256[] memory remainingShipIds = new uint256[](0);

    for (uint i = 0; i < winnerRoster.shipIds.length; i++) {
      ShipData memory ship = Ship.get(winnerRoster.shipIds[i]);
      if (ship.healthPoints > 0) {
        remainingShipIds = ShipIdUtil.addShipIdToEnd(remainingShipIds, winnerRoster.shipIds[i]);
      } else {
        Ship.deleteRecord(winnerRoster.shipIds[i]);
      }
    }

    uint32 newSpeed = winnerRoster.calculateRosterSpeed();
    return (remainingShipIds, newSpeed);
  }
}
