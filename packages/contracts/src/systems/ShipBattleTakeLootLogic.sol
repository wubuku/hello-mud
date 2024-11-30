// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ShipBattleLootTaken } from "./ShipBattleEvents.sol";
import { ShipBattleData, PlayerData, RosterData, Ship, Roster, Player } from "../codegen/index.sol";
import { BattleStatus } from "./BattleStatus.sol";
import { RosterStatus } from "./RosterStatus.sol";
import { ItemIdQuantityPair } from "../systems/ItemIdQuantityPair.sol";
import { ExperienceTableUtil } from "../utils/ExperienceTableUtil.sol";
import { ShipBattleUtil } from "../utils/ShipBattleUtil.sol";
import { RosterUtil } from "../utils/RosterUtil.sol";
import { RosterId } from "../systems/RosterId.sol";
import { RosterDataInstance } from "../utils/RosterDataInstance.sol";
import { ShipDelegatecallLib } from "./ShipDelegatecallLib.sol";
import { SailIntPointLib } from "./SailIntPointLib.sol";
import { Coordinates } from "./Coordinates.sol";
import { UpdateLocationParams } from "./UpdateLocationParams.sol";
import { SailIntPointData } from "../codegen/index.sol";
import { RosterDelegatecallLib } from "./RosterDelegatecallLib.sol";
import { RosterCleanUpBattleResult } from "./RosterCleanUpBattleResult.sol";

library ShipBattleTakeLootLogic {
  using RosterDataInstance for RosterData;

  uint8 constant CHOICE_TAKE_ALL = 1;
  uint8 constant CHOICE_LEAVE_IT = 2; // NOTE: DON'T use 0, because it's the default value in Solidity
  uint64 constant LOOT_TAKING_TIME_LIMIT = 30; // 30 seconds

  error InitiatorNotDestroyed(uint256 initiatorPlayerId, uint32 initiatorRosterSequenceNumber);
  error ResponderNotDestroyed(uint256 responderPlayerId, uint32 responderRosterSequenceNumber);
  error InvalidWinner(uint8 winner);
  error BattleNotEnded(uint8 status);
  error InvalidLoserStatus(uint8 status);
  error WinnerNotSet();
  error BattleEndedAtNotSet();
  error PlayerHasNoClaimedIsland();

  function verify(
    uint256 id,
    uint8 choice,
    ShipBattleData memory shipBattleData
  ) internal returns (ShipBattleLootTaken memory) {
    if (shipBattleData.status != uint8(BattleStatus.ENDED)) revert BattleNotEnded(shipBattleData.status);
    if (shipBattleData.winner == 0) revert WinnerNotSet();

    (
      RosterId memory winnerRosterId,
      RosterData memory winnerRoster,
      RosterId memory loserRosterId,
      RosterData memory loserRoster,
      uint256 winnerPlayerId,
      uint256 loserPlayerId,
      uint32 winnerIncreasedExperience,
      uint32 loserIncreasedExperience
    ) = determineWinnerAndLoser(id, shipBattleData);

    choice = determineChoice(choice, winnerRoster, shipBattleData.endedAt);

    if (loserRoster.status != uint8(RosterStatus.DESTROYED)) revert InvalidLoserStatus(loserRoster.status);

    // (uint256[] memory shipIds, ItemIdQuantityPair[] memory loot) = removeLooserShipsAndCalculateLoot(
    //   loserRoster,
    //   choice
    // );
    // loserRoster.shipIds = shipIds;
    // (winnerRoster.shipIds, winnerRoster.speed) = removeDestroyedWinnerShips(winnerRoster);
    //RosterDelegatecallLib:
    //  function cleanUpBattleDestroyedShips(uint256 playerId, uint32 sequenceNumber, uint256 loserRosterIdPlayerId, uint32 loserRosterIdSequenceNumber, uint8 choice) internal returns (RosterCleanUpBattleResult memory) {
    RosterCleanUpBattleResult memory cleanUpResult = RosterDelegatecallLib.cleanUpBattleDestroyedShips(
      winnerRosterId.playerId,
      winnerRosterId.sequenceNumber,
      loserRosterId.playerId,
      loserRosterId.sequenceNumber,
      choice
    );
    winnerRoster.shipIds = cleanUpResult.winnerRemainingShipIds;
    winnerRoster.speed = cleanUpResult.winnerNewSpeed;
    // Don't use cleanUpResult.loserDestroyedShipIds;
    uint256[] memory loserRemainingShipIds = new uint256[](0);
    loserRoster.shipIds = loserRemainingShipIds;
    ItemIdQuantityPair[] memory loot = cleanUpResult.loot;

    uint64 lootedAt = uint64(block.timestamp);
    updateWinnerRosterStatus(winnerRosterId, winnerRoster, lootedAt);
    updateLoserRosterStatus(
      loserRosterId,
      loserRoster,
      Player.get(loserPlayerId),
      lootedAt
    );
    shipBattleData.status = uint8(BattleStatus.LOOTED);

    return
      createShipBattleLootTaken(
        id,
        choice,
        loot,
        lootedAt,
        winnerPlayerId,
        loserPlayerId,
        winnerIncreasedExperience,
        loserIncreasedExperience
      );
  }

  function determineWinnerAndLoser(
    uint256 shipBattleId,
    ShipBattleData memory shipBattleData
  )
    private
    view
    returns (
      RosterId memory winnerRosterId,
      RosterData memory winnerRoster,
      RosterId memory loserRosterId,
      RosterData memory loserRoster,
      uint256 winnerPlayerId,
      uint256 loserPlayerId,
      uint32 winnerIncreasedExperience,
      uint32 loserIncreasedExperience
    )
  {
    RosterId memory initiatorId = RosterId(
      shipBattleData.initiatorRosterPlayerId,
      shipBattleData.initiatorRosterSequenceNumber
    );
    RosterId memory responderId = RosterId(
      shipBattleData.responderRosterPlayerId,
      shipBattleData.responderRosterSequenceNumber
    );
    RosterData memory initiator = Roster.get(initiatorId.playerId, initiatorId.sequenceNumber);
    RosterData memory responder = Roster.get(responderId.playerId, responderId.sequenceNumber);

    ShipBattleUtil.assertIdsAreConsistent(shipBattleId, shipBattleData, initiatorId, initiator, responderId, responder);

    bool isInitiatorWinner = shipBattleData.winner == ShipBattleUtil.INITIATOR;

    if (isInitiatorWinner) {
      if (!responder.isDestroyed()) revert ResponderNotDestroyed(responderId.playerId, responderId.sequenceNumber);
      (winnerRosterId, winnerRoster, loserRosterId, loserRoster) = (initiatorId, initiator, responderId, responder);
      (winnerPlayerId, loserPlayerId) = (initiatorId.playerId, responderId.playerId);
      winnerIncreasedExperience = getWinnerIncreasedExperience(shipBattleData.initiatorExperiences);
      loserIncreasedExperience = getLoserIncreasedExperience(shipBattleData.responderExperiences);
    } else if (shipBattleData.winner == ShipBattleUtil.RESPONDER) {
      if (!initiator.isDestroyed()) revert InitiatorNotDestroyed(initiatorId.playerId, initiatorId.sequenceNumber);
      (winnerRosterId, winnerRoster, loserRosterId, loserRoster) = (responderId, responder, initiatorId, initiator);
      (winnerPlayerId, loserPlayerId) = (responderId.playerId, initiatorId.playerId);
      winnerIncreasedExperience = getWinnerIncreasedExperience(shipBattleData.responderExperiences);
      loserIncreasedExperience = getLoserIncreasedExperience(shipBattleData.initiatorExperiences);
    } else {
      revert InvalidWinner(shipBattleData.winner);
    }
  }

  function determineChoice(
    uint8 choice,
    //uint256 winnerPlayerId,
    //uint32 winnerRosterSequenceNumber,
    RosterData memory winnerRoster,
    uint64 endedAt
  ) private view returns (uint8) {
    if (winnerRoster.environmentOwned) {
      return CHOICE_TAKE_ALL;
    } else {
      if (endedAt == 0) revert BattleEndedAtNotSet();
      if (uint64(block.timestamp) >= endedAt + LOOT_TAKING_TIME_LIMIT) {
        return CHOICE_TAKE_ALL;
      } else {
        // RosterUtil.assertPlayerIsRosterOwner(
        //   winnerPlayerId,
        //   RosterId(winnerPlayerId, winnerRosterSequenceNumber)
        // );
        //TODO permission_util::assert_sender_is_player_owner(player, ctx);

        return choice;
      }
    }
  }

  function createShipBattleLootTaken(
    uint256 id,
    uint8 choice,
    ItemIdQuantityPair[] memory loot,
    uint64 lootedAt,
    uint256 winnerPlayerId,
    uint256 loserPlayerId,
    uint32 winnerIncreasedExperience,
    uint32 loserIncreasedExperience
  ) private view returns (ShipBattleLootTaken memory) {
    PlayerData memory winnerPlayer = Player.get(winnerPlayerId);
    PlayerData memory loserPlayer = Player.get(loserPlayerId);

    uint16 newLevel = ExperienceTableUtil.calculateNewLevel(
      uint16(winnerPlayer.level),
      winnerPlayer.experience,
      winnerIncreasedExperience
    );

    uint16 loserNewLevel = ExperienceTableUtil.calculateNewLevel(
      uint16(loserPlayer.level),
      loserPlayer.experience,
      loserIncreasedExperience
    );

    ShipBattleLootTaken memory e;
    e.id = id;
    e.choice = choice;
    e.loot = loot;
    e.lootedAt = lootedAt;
    e.increasedExperience = winnerIncreasedExperience;
    e.newLevel = newLevel;
    e.loserIncreasedExperience = loserIncreasedExperience;
    e.loserNewLevel = loserNewLevel;
    return e;
  }

  function mutate(
    ShipBattleLootTaken memory shipBattleLootTaken,
    ShipBattleData memory shipBattleData
  ) internal returns (ShipBattleData memory) {
    RosterId memory initiatorId = RosterId(
      shipBattleData.initiatorRosterPlayerId,
      shipBattleData.initiatorRosterSequenceNumber
    );
    RosterId memory responderId = RosterId(
      shipBattleData.responderRosterPlayerId,
      shipBattleData.responderRosterSequenceNumber
    );
    RosterData memory initiator = Roster.get(initiatorId.playerId, initiatorId.sequenceNumber);
    RosterData memory responder = Roster.get(responderId.playerId, responderId.sequenceNumber);

    uint256 winnerPlayerId;
    PlayerData memory winnerPlayer;
    uint256 loserPlayerId;
    PlayerData memory loserPlayer;
    RosterId memory winnerRosterId;
    RosterData memory winnerRoster;
    RosterId memory loserRosterId;
    RosterData memory loserRoster;

    if (shipBattleData.winner == ShipBattleUtil.INITIATOR) {
      winnerRosterId = initiatorId;
      winnerRoster = initiator;
      loserRosterId = responderId;
      loserRoster = responder;
      winnerPlayerId = initiatorId.playerId;
      winnerPlayer = Player.get(winnerPlayerId);
      loserPlayerId = responderId.playerId;
      loserPlayer = Player.get(loserPlayerId);
    } else if (shipBattleData.winner == ShipBattleUtil.RESPONDER) {
      winnerRosterId = responderId;
      winnerRoster = responder;
      loserRosterId = initiatorId;
      loserRoster = initiator;
      winnerPlayerId = responderId.playerId;
      winnerPlayer = Player.get(winnerPlayerId);
      loserPlayerId = initiatorId.playerId;
      loserPlayer = Player.get(loserPlayerId);
    } else {
      revert InvalidWinner(shipBattleData.winner);
    }

    //updateWinnerInventory(winnerRoster, shipBattleLootTaken.loot);
    uint256 lastShipId = winnerRoster.getLastShipId();
    ShipDelegatecallLib.increaseShipInventory(lastShipId, shipBattleLootTaken.loot);

    //NOTE: There is no remote call to Player.IncreaseExperienceAndItems here;
    // As well as increased the E-Roster Owner's experience.
    winnerPlayer.experience += shipBattleLootTaken.increasedExperience;
    winnerPlayer.level = shipBattleLootTaken.newLevel;

    loserPlayer.experience += shipBattleLootTaken.loserIncreasedExperience;
    loserPlayer.level = shipBattleLootTaken.loserNewLevel;

    Player.set(winnerPlayerId, winnerPlayer);
    Player.set(loserPlayerId, loserPlayer);

    return shipBattleData;
  }

  function getWinnerIncreasedExperience(uint32[] memory xps) internal pure returns (uint32) {
    uint32 sum = 0;
    for (uint i = 0; i < xps.length; i++) {
      sum += xps[i];
    }
    return sum;
  }

  function getLoserIncreasedExperience(uint32[] memory xps) internal pure returns (uint32) {
    uint32 vc = 0;
    uint32 sum = 0;
    for (uint i = 0; i < xps.length; i++) {
      if (xps[i] > 0) {
        vc++;
      }
      sum += xps[i];
    }
    return (vc >= 2) ? sum : 0;
  }

  function updateWinnerRosterStatus(
    RosterId memory winnerRosterId,
    RosterData memory winnerRoster,
    uint64 lootedAt
  ) private {
    winnerRoster.shipBattleId = 0;
    if (
      winnerRoster.targetCoordinatesX != 0 &&
      winnerRoster.targetCoordinatesY != 0 &&
      (winnerRoster.targetCoordinatesX != winnerRoster.updatedCoordinatesX ||
        winnerRoster.targetCoordinatesY != winnerRoster.updatedCoordinatesY)
    ) {
      winnerRoster.status = uint8(RosterStatus.UNDERWAY);

      // Get all intermediate points
      SailIntPointData[] memory allIntPoints = SailIntPointLib.getAllSailIntermediatePoints(
        winnerRosterId.playerId,
        winnerRosterId.sequenceNumber
      );

      // Filter remaining points based on currentSailSegment
      uint16 currentSailSegment = winnerRoster.currentSailSegment;
      if (currentSailSegment > allIntPoints.length) {
        currentSailSegment = uint16(allIntPoints.length);
      }
      Coordinates[] memory remainingIntPoints = new Coordinates[](allIntPoints.length - currentSailSegment);
      for (uint64 i = currentSailSegment; i < allIntPoints.length; i++) {
        remainingIntPoints[i - currentSailSegment] = Coordinates(
          allIntPoints[i].coordinatesX,
          allIntPoints[i].coordinatesY
        );
      }

      UpdateLocationParams memory updateLocationParams = UpdateLocationParams({
        updatedCoordinates: Coordinates(winnerRoster.updatedCoordinatesX, winnerRoster.updatedCoordinatesY),
        updatedSailSegment: 0,
        updatedAt: lootedAt
      });
      // Update first!
      Roster.set(winnerRosterId.playerId, winnerRosterId.sequenceNumber, winnerRoster);
      // Then call the setSail function!
      RosterDelegatecallLib.setSail(
        winnerRosterId.playerId,
        winnerRosterId.sequenceNumber,
        winnerRoster.targetCoordinatesX,
        winnerRoster.targetCoordinatesY,
        0, //sailDuration,
        updateLocationParams,
        remainingIntPoints
      );
    } else {
      winnerRoster.status = uint8(RosterStatus.AT_ANCHOR);
      Roster.set(winnerRosterId.playerId, winnerRosterId.sequenceNumber, winnerRoster);
    }
  }

  function updateLoserRosterStatus(
    RosterId memory loserRosterId,
    RosterData memory loserRoster,
    PlayerData memory loserPlayer,
    uint64 lootedAt
  ) private {
    if (loserRoster.environmentOwned) {
      return; //loserRoster;
    }
    uint32 loserRosterSequenceNumber = loserRosterId.sequenceNumber;
    if (loserPlayer.claimedIslandX == 0 && loserPlayer.claimedIslandY == 0) {
      revert PlayerHasNoClaimedIsland();
    }

    loserRoster.shipBattleId = 0;
    (uint32 x, uint32 y) = RosterUtil.getRosterOriginCoordinates(
      loserPlayer.claimedIslandX,
      loserPlayer.claimedIslandY,
      loserRosterSequenceNumber
    );
    loserRoster.updatedCoordinatesX = x;
    loserRoster.updatedCoordinatesY = y;
    loserRoster.coordinatesUpdatedAt = lootedAt;
    loserRoster.status = uint8(RosterStatus.AT_ANCHOR);
    
    Roster.set(loserRosterId.playerId, loserRosterId.sequenceNumber, loserRoster);
  }
}