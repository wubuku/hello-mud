// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { CommentUpdated } from "./ArticleEvents.sol";
import { ArticleData } from "../codegen/index.sol";
import { CommentData } from "../codegen/index.sol";
import { Comment } from "../codegen/index.sol";

/**
 * @title ArticleUpdateCommentLogic Library
 * @dev Implements the Article.UpdateComment method.
 */
library ArticleUpdateCommentLogic {
  /**
   * @notice Verifies the Article.UpdateComment command.
   * @param articleData The current state the Article.
   * @return A CommentUpdated event struct.
   */
  function verify(
    uint64 id,
    uint64 commentSeqId,
    string memory commenter,
    string memory body,
    ArticleData memory articleData
  ) internal pure returns (CommentUpdated memory) {
    return CommentUpdated({
      id: id,
      commentSeqId: commentSeqId,
      commenter: commenter,
      body: body
    });
  }

  /**
   * @notice Performs the state mutation operation of Article.UpdateComment method.
   * @dev This function is called after verification to update the Article's state.
   * @param commentUpdated The CommentUpdated event struct from the verify function.
   * @param articleData The current state of the Article.
   * @return The new state of the Article.
   */
  function mutate(
    CommentUpdated memory commentUpdated,
    ArticleData memory articleData
  ) internal returns (ArticleData memory) {
    CommentData memory newComment = CommentData({
      commenter: commentUpdated.commenter,
      body: commentUpdated.body
    });
    Comment.set(commentUpdated.id, commentUpdated.commentSeqId, newComment);

    return articleData;
  }
}
