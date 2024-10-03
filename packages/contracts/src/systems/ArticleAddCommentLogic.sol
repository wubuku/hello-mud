// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { CommentAdded } from "./ArticleEvents.sol";
import { ArticleData } from "../codegen/index.sol";
import { CommentSeqIdGenerator } from "../codegen/index.sol";
import { CommentData } from "../codegen/index.sol";
import { Comment } from "../codegen/index.sol";
import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";

/**
 * @title ArticleAddCommentLogic Library
 * @dev Implements the Article.AddComment method.
 */
library ArticleAddCommentLogic {
  /**
   * @notice Verifies the Article.AddComment command.
   * @param articleData The current state the Article.
   * @return A CommentAdded event struct.
   */
  function verify(
    uint64 id,
    string memory commenter,
    string memory body,
    ArticleData memory articleData
  ) internal view returns (CommentAdded memory) {
    // Check if the article exists
    require(bytes(articleData.title).length > 0, "Article does not exist");

    // Check if the comment body is not empty
    require(bytes(body).length > 0, "Comment body cannot be empty");

    // Check if the commenter name is not empty
    require(bytes(commenter).length > 0, "Commenter name cannot be empty");

    // Generate the new comment sequence ID
    uint64 commentSeqId = CommentSeqIdGenerator.get(id) + 1;

    return CommentAdded({
      id: id,
      commentSeqId: commentSeqId,
      commenter: commenter,
      body: body
    });
  }

  /**
   * @notice Performs the state mutation operation of Article.AddComment method.
   * @dev This function is called after verification to update the Article's state.
   * @param commentAdded The CommentAdded event struct from the verify function.
   * @param articleData The current state of the Article.
   * @return The new state of the Article.
   */
  function mutate(
    CommentAdded memory commentAdded,
    ArticleData memory articleData
  ) internal returns (ArticleData memory) {
    // Update the comment sequence ID
    CommentSeqIdGenerator.set(commentAdded.id, commentAdded.commentSeqId);

    // Create and store the new comment
    CommentData memory newComment = CommentData({
      commenter: commentAdded.commenter,
      body: commentAdded.body
    });
    Comment.set(commentAdded.id, commentAdded.commentSeqId, newComment);

    // The ArticleData itself doesn't change, so we return it as is
    return articleData;
  }
}
