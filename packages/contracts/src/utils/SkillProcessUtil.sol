// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "../systems/SkillType.sol";
import "../systems/SkillTypeItemIdPair.sol";
import "../systems/SkillProcessId.sol";
import { SkillProcessData } from "../codegen/index.sol";

library SkillProcessUtil {
  error InvalidPlayerId();
  error IncorrectSkillType();
  error IncorrectItemId();

  function skillTypeMaxSequenceNumber(uint8 skillType) public pure returns (uint8) {
    return skillType == SkillType.FARMING ? 1 : 0;
  }

  function assertIdsAreConsistentForStartingCreation(
    uint256 playerId,
    SkillTypeItemIdPair memory itemCreationId,
    SkillProcessId memory skillProcessId
  ) public pure returns (uint256, uint8, uint32) {
    uint256 _playerId = skillProcessId.playerId;
    if (playerId != _playerId) revert InvalidPlayerId();

    uint8 skillType = itemCreationId.skillType;
    if (skillType != skillProcessId.skillType) revert IncorrectSkillType();
    uint32 itemId = itemCreationId.itemId;

    return (_playerId, skillType, itemId);
  }

  function assertIdsAreConsistentForCompletingCreation(
    uint256 playerId,
    SkillTypeItemIdPair memory itemCreationId,
    SkillProcessId memory skillProcessId,
    SkillProcessData memory skillProcessData
  ) public pure returns (uint256, uint8, uint32) {
    (uint256 _playerId, uint8 skillType, uint32 itemId) = assertIdsAreConsistentForStartingCreation(
      playerId,
      itemCreationId,
      skillProcessId
    );
    if (itemId != skillProcessData.itemId) revert IncorrectItemId();
    return (_playerId, skillType, itemId);
  }
}
