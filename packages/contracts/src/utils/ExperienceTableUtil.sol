// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { XpTableLevelLib, XpTableLevelData } from "../systems/XpTableLevelLib.sol";

library ExperienceTableUtil {
  error ExperienceTableNotInitialized();

  /**
   * @dev Calculates the new level based on the old level, old experience, and experience gained.
   * @param oldLevel The current level of the player
   * @param oldExperience The current experience of the player
   * @param experienceGained The amount of experience gained
   * @return The new level of the player after gaining experience
   */
  function calculateNewLevel(
    uint16 oldLevel,
    uint32 oldExperience,
    uint32 experienceGained
  ) internal view returns (uint16) {
    uint32 newExperience = oldExperience + experienceGained;
    uint16 newLevel = oldLevel;

    uint64 xpLevelsLen = XpTableLevelLib.getLevelCount();

    if (xpLevelsLen <= 1) {
      revert ExperienceTableNotInitialized();
    }

    uint64 maxLevel = xpLevelsLen - 1;
    if (maxLevel > oldLevel) {
      for (uint64 i = uint64(oldLevel) + 1; i <= maxLevel; i++) {
        XpTableLevelData memory xpLevel = XpTableLevelLib.getLevelByIndex(i);
        if (newExperience >= xpLevel.experience) {
          newLevel = uint16(xpLevel.level);
        } else {
          break;
        }
      }
    }

    return newLevel;
  }
}
