// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "../systems/SkillType.sol";
import "../systems/SkillTypeItemIdPair.sol";
import "../systems/SkillProcessId.sol";
import { SkillProcessData } from "../codegen/index.sol";

library SkillProcessUtil {
  error InvalidPlayerId(uint256 expectedPlayerId, uint256 actualPlayerId);
  error IncorrectSkillType(uint8 expectedSkillType, uint8 actualSkillType);
  error IncorrectItemId(uint32 expectedItemId, uint32 actualItemId);

  function skillTypeMaxSequenceNumber(uint8 skillType) internal pure returns (uint8) {
    return skillType == SkillType.FARMING ? 1 : 0;
  }

  // Alias of `assertIdsAreConsistentForStartingProduction`.
  function assertIdsAreConsistentForStartingCreation(
    uint256 playerId,
    SkillTypeItemIdPair memory itemCreationId,
    SkillProcessId memory skillProcessId
  ) internal pure returns (uint256, uint8, uint32) {
    return assertIdsAreConsistentForStartingProduction(playerId, itemCreationId, skillProcessId);
  }

  function assertIdsAreConsistentForStartingProduction(
    uint256 playerId,
    SkillTypeItemIdPair memory itemCreationId,
    SkillProcessId memory skillProcessId
  ) internal pure returns (uint256, uint8, uint32) {
    uint256 _playerId = skillProcessId.playerId;
    if (playerId != _playerId) revert InvalidPlayerId(playerId, _playerId);

    uint8 skillType = itemCreationId.skillType;
    if (skillType != skillProcessId.skillType) revert IncorrectSkillType(skillType, skillProcessId.skillType);
    uint32 itemId = itemCreationId.itemId;

    return (_playerId, skillType, itemId);
  }

  function assertIdsAreConsistentForCompletingCreation(
    uint256 playerId,
    SkillTypeItemIdPair memory itemCreationId,
    SkillProcessId memory skillProcessId,
    SkillProcessData memory skillProcessData
  ) internal pure returns (uint256, uint8, uint32) {
    return assertIdsAreConsistentForCompletingProduction(playerId, itemCreationId, skillProcessId, skillProcessData);
  }

  function assertIdsAreConsistentForCompletingProduction(
    uint256 playerId,
    SkillTypeItemIdPair memory itemCreationId,
    SkillProcessId memory skillProcessId,
    SkillProcessData memory skillProcessData
  ) internal pure returns (uint256, uint8, uint32) {
    (uint256 _playerId, uint8 skillType, uint32 itemId) = assertIdsAreConsistentForStartingCreation(
      playerId,
      itemCreationId,
      skillProcessId
    );
    if (itemId != skillProcessData.itemId) revert IncorrectItemId(itemId, skillProcessData.itemId);
    return (_playerId, skillType, itemId);
  }
}
