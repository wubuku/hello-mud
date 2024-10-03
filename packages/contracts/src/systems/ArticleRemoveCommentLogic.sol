// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { CommentRemoved } from "./ArticleEvents.sol";
import { ArticleData } from "../codegen/index.sol";
import { CommentData } from "../codegen/index.sol";
import { Comment } from "../codegen/index.sol";

/**
 * @title ArticleRemoveCommentLogic Library
 * @dev Implements the Article.RemoveComment method.
 */
library ArticleRemoveCommentLogic {
  /**
   * @notice Verifies the Article.RemoveComment command.
   * @param articleData The current state the Article.
   * @return A CommentRemoved event struct.
   */
  function verify(
    uint64 id,
    uint64 commentSeqId,
    ArticleData memory articleData
  ) internal pure returns (CommentRemoved memory) {
    return CommentRemoved({
      id: id,
      commentSeqId: commentSeqId
    });
  }

  /**
   * @notice Performs the state mutation operation of Article.RemoveComment method.
   * @dev This function is called after verification to update the Article's state.
   * @param commentRemoved The CommentRemoved event struct from the verify function.
   * @param articleData The current state of the Article.
   * @return The new state of the Article.
   */
  function mutate(
    CommentRemoved memory commentRemoved,
    ArticleData memory articleData
  ) internal returns (ArticleData memory) {
    Comment.deleteRecord(commentRemoved.id, commentRemoved.commentSeqId);

    return articleData;
  }
}
