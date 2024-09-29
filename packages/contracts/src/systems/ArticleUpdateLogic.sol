// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ArticleUpdated } from "./ArticleEvents.sol";
import { ArticleData } from "../codegen/index.sol";
//import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";

/**
 * @title ArticleUpdateLogic Library
 * @dev Implements the Article.Update method.
 */
library ArticleUpdateLogic {
  /**
   * @notice Verifies the Article.Update command.
   * @param articleData The current state the Article.
   * @return A ArticleUpdated event struct.
   */
  function verify(
    uint64 id,
    address author,
    string memory title,
    string memory body,
    ArticleData memory articleData
  ) internal pure returns (ArticleUpdated memory) {
    return ArticleUpdated(id, author, title, body);
  }

  /**
   * @notice Performs the state mutation operation of Article.Update method.
   * @dev This function is called after verification to update the Article's state.
   * @param articleUpdated The ArticleUpdated event struct from the verify function.
   * @param articleData The current state of the Article.
   * @return The new state of the Article.
   */
  function mutate(
    ArticleUpdated memory articleUpdated,
    ArticleData memory articleData
  ) internal pure returns (ArticleData memory) {
    articleData.author = articleUpdated.author;
    articleData.title = articleUpdated.title;
    articleData.body = articleUpdated.body;
    return articleData;
  }
}
