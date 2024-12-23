// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { RosterMultiShipsTransferred } from "./RosterEvents.sol";
import { RosterData, ShipData, Roster, Ship } from "../codegen/index.sol";
import { RosterDataInstance } from "../utils/RosterDataInstance.sol";
import { ShipIdUtil } from "../utils/ShipIdUtil.sol";
import { RosterSequenceNumber } from "./RosterSequenceNumber.sol";
import { RosterUtil } from "../utils/RosterUtil.sol";
import { PlayerUtil } from "../utils/PlayerUtil.sol";
import { ShipUtil } from "../utils/ShipUtil.sol";
import { PlayerData, Player } from "../codegen/index.sol";
import { ShipUtil } from "../utils/ShipUtil.sol";
import { RosterStatus } from "../systems/RosterStatus.sol";
import { Coordinates } from "../systems/Coordinates.sol";
import { RosterDelegatecallLib } from "./RosterDelegatecallLib.sol";
import { UpdateLocationParams } from "./UpdateLocationParams.sol";
import { TwoRostersLocationUpdateParams } from "./TwoRostersLocationUpdateParams.sol";

library RosterTransferMultiShipsLogic {
  error EmptyShipIdsInSourceRoster(uint256 rosterPlayerId, uint32 rosterSequenceNumber);
  error RostersTooFarAway(
    uint256 rosterPlayerId,
    uint32 rosterSequenceNumber,
    uint256 toRosterPlayerId,
    uint32 toRosterSequenceNumber
  );
  error RosterInBattle(uint256 rosterPlayerId, uint32 rosterSequenceNumber, uint256 battleId);
  error ToRosterInBattle(uint256 toRosterPlayerId, uint32 toRosterSequenceNumber, uint256 battleId);
  error RosterNotExists(uint256 rosterPlayerId, uint32 rosterSequenceNumber);
  error ShipNotInRoster(uint256 shipId);
  error NotEnoughSpaceInToRoster(uint256 toRosterPlayerId, uint32 toRosterSequenceNumber);
  //From SequenceNumber should not same as To SequenceNumber
  error RosterSequenceNumberCantSame(uint32 sequenceNumber);
  error NotSamePlayer(uint256 playerId, uint256 toRosterPlayerId);

  using RosterDataInstance for RosterData;

  function verify(
    uint256 playerId,
    uint32 sequenceNumber,
    uint256[] memory shipIds,
    uint256 toRosterPlayerId,
    uint32 toRosterSequenceNumber,
    uint64 toPosition,
    TwoRostersLocationUpdateParams memory locationUpdateParams,
    RosterData memory rosterData
  ) internal view returns (RosterMultiShipsTransferred memory) {
    if (sequenceNumber != RosterSequenceNumber.UNASSIGNED_SHIPS) {
      rosterData.assertRosterShipsNotFull();
    }
    if (sequenceNumber == toRosterSequenceNumber) {
      revert RosterSequenceNumberCantSame(sequenceNumber);
    }
    //Two rosters both can't in battle.
    if (rosterData.shipBattleId != 0) {
      revert RosterInBattle(playerId, sequenceNumber, rosterData.shipBattleId);
    }
    //通过以下两个判断来断定两个船队同属于一个玩家
    PlayerUtil.assertSenderIsPlayerOwner(playerId);
    if (playerId != toRosterPlayerId) {
      revert NotSamePlayer(playerId, toRosterPlayerId);
    }
    for (uint256 i = 0; i < shipIds.length; i++) {
      if (!ShipIdUtil.containsShipId(rosterData.shipIds, shipIds[i])) {
        revert ShipNotInRoster(shipIds[i]);
      }
    }

    RosterData memory toRoster = Roster.get(toRosterPlayerId, toRosterSequenceNumber);
    if (toRoster.shipBattleId != 0) {
      revert ToRosterInBattle(toRosterPlayerId, toRosterSequenceNumber, toRoster.shipBattleId);
    }

    if (toRosterSequenceNumber != RosterSequenceNumber.UNASSIGNED_SHIPS) {
      toRoster.assertRosterShipsNotFull();
      if (toRoster.shipIds.length + shipIds.length > RosterDataInstance.MAX_SHIPS_PER_ROSTER) {
        revert NotEnoughSpaceInToRoster(toRosterPlayerId, toRosterSequenceNumber);
      }
    }

    //只有当船队的序号不是0，并且船队当前是航行状态和传入的相关参数都不是 0 的情况下才需要更新位置
    if (
      sequenceNumber != 0 && // 不能是 Roster0
      rosterData.status == RosterStatus.UNDERWAY && //航行中
      locationUpdateParams.coordinates.x != 0 && // 设置了新的坐标
      locationUpdateParams.coordinates.y != 0 &&
      locationUpdateParams.updatedAt != 0 // 设置了时间
    ) {
      RosterDelegatecallLib.updateLocation(
        playerId,
        sequenceNumber,
        UpdateLocationParams({
          updatedCoordinates: Coordinates(locationUpdateParams.coordinates.x, locationUpdateParams.coordinates.y),
          updatedSailSegment: locationUpdateParams.updatedSailSeg,
          updatedAt: locationUpdateParams.updatedAt
        })
      );
      rosterData = Roster.get(playerId, sequenceNumber);
    }
    if (
      toRosterSequenceNumber != 0 && // 不能是 Roster0
      toRoster.status == RosterStatus.UNDERWAY && //航行中
      locationUpdateParams.toRosterCoordinates.x != 0 && // 设置了新的坐标
      locationUpdateParams.toRosterCoordinates.y != 0 &&
      locationUpdateParams.updatedAt != 0 // 设置了时间
    ) {
      RosterDelegatecallLib.updateLocation(
        toRosterPlayerId,
        toRosterSequenceNumber,
        UpdateLocationParams({
          updatedCoordinates: Coordinates(
            locationUpdateParams.toRosterCoordinates.x,
            locationUpdateParams.toRosterCoordinates.y
          ),
          updatedSailSegment: locationUpdateParams.toRosterUpdatedSailSeg,
          updatedAt: locationUpdateParams.updatedAt
        })
      );
      toRoster = Roster.get(toRosterPlayerId, toRosterSequenceNumber);
    }

    uint64 currentTimestamp = uint64(block.timestamp);
    //两只船队是否足够近，如果其中一只船队是 Roster0，那么将用岛屿的坐标来代替
    //另一个船队的坐标用 otherX 和 otherY 来表示
    uint32 otherX = 0;
    uint32 otherY = 0;
    if (sequenceNumber == 0) {
      otherX = toRoster.updatedCoordinatesX;
      otherY = toRoster.updatedCoordinatesY;
    }
    if (toRosterSequenceNumber == 0) {
      otherX = rosterData.updatedCoordinatesX;
      otherY = rosterData.updatedCoordinatesY;
    }
    //Roster0的坐标用岛屿的坐标来代替
    PlayerData memory playerData = Player.get(playerId);
    uint32 roster0X = playerData.claimedIslandX;
    uint32 roster0Y = playerData.claimedIslandY;

    if (!RosterDataInstance.areRostersCloseEnoughToTransfer(roster0X, roster0Y, otherX, otherY)) {
      revert RostersTooFarAway(playerId, sequenceNumber, toRosterPlayerId, toRosterSequenceNumber);
    }

    return
      RosterMultiShipsTransferred({
        playerId: playerId,
        sequenceNumber: sequenceNumber,
        shipIds: shipIds,
        toRosterPlayerId: toRosterPlayerId,
        toRosterSequenceNumber: toRosterSequenceNumber,
        toPosition: toPosition,
        locationUpdateParams: locationUpdateParams,
        transferredAt: currentTimestamp
      });
  }

  function mutate(
    RosterMultiShipsTransferred memory rosterMultiShipsTransferred,
    RosterData memory rosterData
  ) internal returns (RosterData memory) {
    rosterData = Roster.get(rosterMultiShipsTransferred.playerId, rosterMultiShipsTransferred.sequenceNumber);
    RosterData memory toRoster = Roster.get(
      rosterMultiShipsTransferred.toRosterPlayerId,
      rosterMultiShipsTransferred.toRosterSequenceNumber
    );
    if (toRoster.status == uint8(0)) {
      revert RosterNotExists(
        rosterMultiShipsTransferred.toRosterPlayerId,
        rosterMultiShipsTransferred.toRosterSequenceNumber
      );
    }

    uint256[] memory shipIds = rosterMultiShipsTransferred.shipIds;
    uint256 playerId = rosterMultiShipsTransferred.playerId;
    uint32 sequenceNumber = rosterMultiShipsTransferred.sequenceNumber;

    if (rosterData.shipIds.length == 0) {
      revert EmptyShipIdsInSourceRoster(playerId, sequenceNumber);
    }

    for (uint256 i = 0; i < shipIds.length; i++) {
      uint256 shipId = shipIds[i];
      ShipData memory shipData = Ship.get(shipId);

      ShipUtil.assertShipOwnership(shipData, shipId, playerId, sequenceNumber);

      rosterData.shipIds = ShipIdUtil.removeShipId(rosterData.shipIds, shipId);
      toRoster.shipIds = ShipIdUtil.addShipId(
        toRoster.shipIds,
        shipId,
        rosterMultiShipsTransferred.toPosition + uint64(i)
      );

      shipData.playerId = rosterMultiShipsTransferred.toRosterPlayerId;
      shipData.rosterSequenceNumber = rosterMultiShipsTransferred.toRosterSequenceNumber;
      Ship.set(shipId, shipData);
    }

    rosterData.speed = rosterData.calculateRosterSpeed();
    rosterData.coordinatesUpdatedAt = rosterMultiShipsTransferred.transferredAt;

    toRoster.speed = toRoster.calculateRosterSpeed();
    toRoster.coordinatesUpdatedAt = rosterMultiShipsTransferred.transferredAt;
    Roster.set(
      rosterMultiShipsTransferred.toRosterPlayerId,
      rosterMultiShipsTransferred.toRosterSequenceNumber,
      toRoster
    );

    return rosterData;
  }
}
