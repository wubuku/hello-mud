// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { RosterShipTransferred } from "./RosterEvents.sol";
import { RosterData, ShipData, Roster, Ship } from "../codegen/index.sol";
import { RosterDataInstance } from "../utils/RosterDataInstance.sol";
import { ShipIdUtil } from "../utils/ShipIdUtil.sol";
import { RosterSequenceNumber } from "./RosterSequenceNumber.sol";
import { RosterUtil } from "../utils/RosterUtil.sol";
import { RosterId } from "./RosterId.sol";
import { PlayerUtil } from "../utils/PlayerUtil.sol";
import { PlayerData, Player } from "../codegen/index.sol";
import { ShipUtil } from "../utils/ShipUtil.sol";
import { RosterStatus } from "../systems/RosterStatus.sol";
import { Coordinates } from "../systems/Coordinates.sol";
import { RosterDelegatecallLib } from "./RosterDelegatecallLib.sol";
import { UpdateLocationParams } from "./UpdateLocationParams.sol";
import { TwoRostersLocationUpdateParams } from "./TwoRostersLocationUpdateParams.sol";

library RosterTransferShipLogic {
  error EmptyShipIdsInSourceRoster(uint256 shipId, uint256 rosterPlayerId, uint32 rosterSequenceNumber);
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
  //From SequenceNumber should not same as To SequenceNumber
  error RosterSequenceNumberCantSame(uint32 sequenceNumber);
  error NotSamePlayer(uint256 playerId, uint256 toRosterPlayerId);

  using RosterDataInstance for RosterData;

  function verify(
    uint256 playerId,
    uint32 sequenceNumber,
    uint256 shipId,
    uint256 toRosterPlayerId,
    uint32 toRosterSequenceNumber,
    uint64 toPosition,
    TwoRostersLocationUpdateParams memory locationUpdateParams,
    RosterData memory rosterData
  ) internal returns (RosterShipTransferred memory) {
    // if (sequenceNumber != RosterSequenceNumber.UNASSIGNED_SHIPS) {
    //   rosterData.assertRosterShipsNotFull();
    // }
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
    //要转移的船只是否在船队中
    if (!ShipIdUtil.containsShipId(rosterData.shipIds, shipId)) {
      revert ShipNotInRoster(shipId);
    }
    //To Roster's information
    RosterData memory toRoster = Roster.get(toRosterPlayerId, toRosterSequenceNumber);
    if (toRosterSequenceNumber != RosterSequenceNumber.UNASSIGNED_SHIPS) {
      toRoster.assertRosterShipsNotFull();
    }
    if (toRoster.shipBattleId != 0) {
      revert ToRosterInBattle(toRosterPlayerId, toRosterSequenceNumber, toRoster.shipBattleId);
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
      RosterShipTransferred({
        playerId: playerId,
        sequenceNumber: sequenceNumber,
        shipId: shipId,
        toRosterPlayerId: toRosterPlayerId,
        toRosterSequenceNumber: toRosterSequenceNumber,
        toPosition: toPosition,
        locationUpdateParams: locationUpdateParams,
        transferredAt: currentTimestamp
      });
  }

  function mutate(
    RosterShipTransferred memory rosterShipTransferred,
    RosterData memory rosterData
  ) internal returns (RosterData memory) {
    //这里必须重读一遍，否则后面使用rosterData的设置都是无用的。
    rosterData = Roster.get(rosterShipTransferred.playerId, rosterShipTransferred.sequenceNumber);
    RosterData memory toRoster = Roster.get(
      rosterShipTransferred.toRosterPlayerId,
      rosterShipTransferred.toRosterSequenceNumber
    );
    //这个判断已经无意义
    // if (toRoster.status == uint8(0)) {
    //   revert RosterNotExists(rosterShipTransferred.toRosterPlayerId, rosterShipTransferred.toRosterSequenceNumber);
    // }
    uint256 shipId = rosterShipTransferred.shipId;
    uint256 playerId = rosterShipTransferred.playerId;
    uint32 sequenceNumber = rosterShipTransferred.sequenceNumber;
    ShipData memory shipData = Ship.get(shipId);

    ShipUtil.assertShipOwnership(shipData, shipId, playerId, sequenceNumber);

    uint64 toPosition = rosterShipTransferred.toPosition;
    uint64 transferredAt = rosterShipTransferred.transferredAt;
    //已经判断过了
    // if (rosterData.shipIds.length == 0) {
    //   revert EmptyShipIdsInSourceRoster(shipId, playerId, sequenceNumber);
    // }
    rosterData.shipIds = ShipIdUtil.removeShipId(rosterData.shipIds, shipId);
    rosterData.speed = rosterData.calculateRosterSpeed();
    rosterData.coordinatesUpdatedAt = transferredAt; // Update the coordinatesUpdatedAt timestamp here?

    //
    // Note: The consistency of the two-way relationship between Roster and Ship is maintained here.
    //
    toRoster.shipIds = ShipIdUtil.addShipId(toRoster.shipIds, shipId, toPosition);

    shipData.playerId = rosterShipTransferred.toRosterPlayerId;
    shipData.rosterSequenceNumber = rosterShipTransferred.toRosterSequenceNumber;
    Ship.set(shipId, shipData);

    toRoster.speed = toRoster.calculateRosterSpeed();
    toRoster.coordinatesUpdatedAt = transferredAt; // Update the coordinatesUpdatedAt timestamp here?
    Roster.set(rosterShipTransferred.toRosterPlayerId, rosterShipTransferred.toRosterSequenceNumber, toRoster);

    return rosterData;
  }
}
