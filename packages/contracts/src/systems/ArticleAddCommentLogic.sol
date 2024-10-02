// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { CommentAdded } from "./ArticleEvents.sol";
import { ArticleData } from "../codegen/index.sol";
import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";
import { Comment, CommentData } from "../codegen/index.sol";

//import { ArticleTagLib } from "./ArticleTagLib.sol";
// You may need to use the ArticleTagLib library to access and modify the state (string) of the ArticleTag entity within the Article aggregate
//import { ArticleTag } from "../codegen/index.sol";
// You may also need to use the ArticleTag library to access the state of the ArticleTag entity within the Article aggregate


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
    uint64 commentSeqId,
    string memory commenter,
    string memory body,
    ArticleData memory articleData
  ) internal view returns (CommentAdded memory) {
    require(id > 0, "Invalid article ID");
    require(bytes(body).length > 0, "Comment body cannot be empty");
    require(bytes(commenter).length > 0, "Commenter name cannot be empty");
    
    address sender = WorldContextConsumerLib._msgSender();
    require(sender != address(0), "Invalid sender");

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
    // Note: In this implementation, we don't modify the ArticleData directly.
    // Instead, we assume that the Comment entity is managed separately.
    // The actual storage of the comment would be handled in the calling contract.
    Comment.set(commentAdded.id, commentAdded.commentSeqId, commentAdded.commenter, commentAdded.body);

    return articleData;
  }
}
