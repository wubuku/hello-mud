// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { System } from "@latticexyz/world/src/System.sol";
import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";
import { ResourceId, WorldResourceIdLib, WorldResourceIdInstance } from "@latticexyz/world/src/WorldResourceId.sol";
import { RESOURCE_SYSTEM } from "@latticexyz/world/src/worldResourceTypes.sol";

import { ShipBattleCommand } from "./ShipBattleCommand.sol";
import { ShipBattle } from "../codegen/index.sol";
import { ShipBattleDelegationLib } from "./ShipBattleDelegationLib.sol";

import { BattleStatus } from "./BattleStatus.sol";

// import { ShipBattleSystem } from "./ShipBattleSystem.sol";
// import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";

// event ErrorOccurred(string reason);
// event LowLevelError(bytes data);

contract ShipBattleServiceSystem is System {
  uint256 constant MAX_NUMBER_OF_ROUNDS = 100;

  function shipBattleServiceInitiateBattleAndAutoPlayTillEnd(
    uint256 playerId,
    uint256 initiatorRosterPlayerId,
    uint32 initiatorRosterSequenceNumber,
    uint256 responderRosterPlayerId,
    uint32 responderRosterSequenceNumber,
    uint32 initiatorCoordinatesX,
    uint32 initiatorCoordinatesY,
    uint16 updatedInitiatorSailSeg,
    uint32 responderCoordinatesX,
    uint32 responderCoordinatesY,
    uint16 updatedResponderSailSeg
  ) public {
    uint256 shipBattleId = ShipBattleDelegationLib.initiateBattle(
      playerId,
      initiatorRosterPlayerId,
      initiatorRosterSequenceNumber,
      responderRosterPlayerId,
      responderRosterSequenceNumber,
      initiatorCoordinatesX,
      initiatorCoordinatesY,
      updatedInitiatorSailSeg,
      responderCoordinatesX,
      responderCoordinatesY,
      updatedResponderSailSeg
    );
    require(shipBattleId != 0, "ShipBattle initiation failed");
    shipBattleServiceAutoPlayTillEnd(shipBattleId, playerId);

    // ResourceId shipBattleSystemId = WorldResourceIdLib.encode({
    //   typeId: RESOURCE_SYSTEM,
    //   namespace: "app",
    //   name: "ShipBattleSystem"
    // });

    // //IBaseWorld world = IBaseWorld(_world());
    // IBaseWorld world = IBaseWorld(WorldContextConsumerLib._world());
    // //address msgSender = _msgSender();
    // address msgSender = WorldContextConsumerLib._msgSender();
    // try
    //   world.callFrom(
    //     msgSender,
    //     shipBattleSystemId,
    //     abi.encodeWithSignature(
    //       "shipBattleInitiateBattle(uint256,uint256,uint32,uint256,uint32,int32,int32,int32,int32)",
    //       playerId,
    //       initiatorRosterPlayerId,
    //       initiatorRosterSequenceNumber,
    //       responderRosterPlayerId,
    //       responderRosterSequenceNumber,
    //       initiatorCoordinatesX,
    //       initiatorCoordinatesY,
    //       responderCoordinatesX,
    //       responderCoordinatesY
    //     )
    //   )
    // returns (bytes memory shipBattleInitiateBattleReturnData) {
    //   uint256 shipBattleId = abi.decode(shipBattleInitiateBattleReturnData, (uint256));
    //   shipBattleServiceAutoPlayTillEnd(shipBattleId, playerId);
    // } catch Error(string memory reason) {
    //   // 捕获带有原因的错误（包括 require 和 revert 带消息的情况）
    //   //emit ErrorOccurred(reason);
    //   revert(string(abi.encodePacked("Error occurred: ", reason)));
    // } catch Panic(uint errorCode) {
    //   // 捕获 Panic 错误（如断言失败、除以零、溢出等）
    //   string memory panicReason = _getPanicReason(errorCode);
    //   revert(string(abi.encodePacked("Panic occurred: ", panicReason)));
    // } catch (bytes memory lowLevelData) {
    //   // 捕获其他错误（包括自定义错误）
    //   //emit LowLevelError(lowLevelData);
    //   //revert("Low level error occurred");

    //   string memory hexString = _bytesToHexString(lowLevelData);
    //   revert(string(abi.encodePacked("Low level error occurred: ", hexString)));

    //   // For example:
    //   // server returned an error response: error code 3: execution reverted: revert:
    //   // Low level error occurred: 0xc86745f9000000000000000000000000f39fd6e51aad88f6f4ce6ab8827279cfffb92266000000000000000000000000a93bbb2b14d6e0a4c2954f5b6fbf60c4fa5a8089
    // }
  }

  function shipBattleServiceAutoPlayTillEnd(uint256 shipBattleId, uint256 playerId) public {
    // ResourceId shipBattleSystemId = WorldResourceIdLib.encode({
    //   typeId: RESOURCE_SYSTEM,
    //   namespace: "app",
    //   name: "ShipBattleSystem"
    // });
    // IBaseWorld world = IBaseWorld(_world());

    for (uint256 i = 0; i < MAX_NUMBER_OF_ROUNDS; i++) {
      uint8 status = ShipBattle.getStatus(shipBattleId);
      if (status == BattleStatus.ENDED) {
        break;
      }
      ShipBattleDelegationLib.makeMove(shipBattleId, ShipBattleCommand.ATTACK);
      // world.callFrom(
      //   _msgSender(),
      //   shipBattleSystemId,
      //   abi.encodeWithSignature("shipBattleMakeMove(uint256,uint8)", shipBattleId, ShipBattleCommand.ATTACK)
      // );
      //if (i == 0) {
      //  break; // Test just the first round
      //}
    }
  }

  function _getPanicReason(uint errorCode) internal pure returns (string memory) {
    if (errorCode == 0x01) return "Assertion failed";
    if (errorCode == 0x11) return "Arithmetic overflow or underflow";
    if (errorCode == 0x12) return "Division or modulo by zero";
    if (errorCode == 0x21) return "Invalid enum value";
    if (errorCode == 0x22) return "Storage byte array that is incorrectly encoded";
    if (errorCode == 0x31) return "pop() on an empty array";
    if (errorCode == 0x32) return "Array index out of bounds";
    if (errorCode == 0x41) return "Allocation of too much memory or array too large";
    if (errorCode == 0x51) return "Call to a zero-initialized variable of internal function type";
    return string(abi.encodePacked("Unknown panic code: ", _uintToString(errorCode)));
  }

  function _uintToString(uint v) internal pure returns (string memory) {
    if (v == 0) return "0";
    uint maxlength = 100;
    bytes memory reversed = new bytes(maxlength);
    uint i = 0;
    while (v != 0) {
      uint remainder = v % 10;
      v = v / 10;
      reversed[i++] = bytes1(uint8(48 + remainder));
    }
    bytes memory s = new bytes(i);
    for (uint j = 0; j < i; j++) {
      s[j] = reversed[i - 1 - j];
    }
    return string(s);
  }

  function _bytesToHexString(bytes memory data) internal pure returns (string memory) {
    bytes memory alphabet = "0123456789abcdef";
    bytes memory str = new bytes(2 + data.length * 2);
    str[0] = "0";
    str[1] = "x";
    for (uint i = 0; i < data.length; i++) {
      str[2 + i * 2] = alphabet[uint8(data[i] >> 4)];
      str[3 + i * 2] = alphabet[uint8(data[i] & 0x0f)];
    }
    return string(str);
  }
}
