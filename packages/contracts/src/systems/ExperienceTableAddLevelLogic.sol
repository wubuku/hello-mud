// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ExperienceLevelAdded } from "./ExperienceTableEvents.sol";
import { XpTableLevelLib } from "./XpTableLevelLib.sol";
import { XpTableLevelData } from "../codegen/index.sol";

library ExperienceTableAddLevelLogic {
  error ELevelNotEqualToIndex();

  function verify(
    uint16 level,
    uint32 experience,
    uint32 difference,
    bool reservedBool1
  ) internal view returns (ExperienceLevelAdded memory) {
    uint64 currentLevelCount = XpTableLevelLib.getLevelCount();
    
    if (level != currentLevelCount) {
      revert ELevelNotEqualToIndex();
    }

    return ExperienceLevelAdded(level, experience, difference);
  }

  function mutate(
    ExperienceLevelAdded memory experienceLevelAdded,
    bool reservedBool1
  ) internal returns (bool) {
    XpTableLevelData memory newLevel = XpTableLevelData({
      level: experienceLevelAdded.level,
      experience: experienceLevelAdded.experience,
      difference: experienceLevelAdded.difference
    });

    XpTableLevelLib.addLevel(newLevel);

    return reservedBool1;
  }
}
