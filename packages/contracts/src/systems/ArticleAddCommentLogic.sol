// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { CommentAdded } from "./ArticleEvents.sol";
import { ArticleData } from "../codegen/index.sol";
import { CommentSeqIdGenerator } from "../codegen/index.sol";
import { CommentData } from "../codegen/index.sol";
import { Comment } from "../codegen/index.sol";
//import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";
//import { CommentData } from "../codegen/index.sol";
//import { Comment } from "../codegen/index.sol";
// You may need to use the Comment library to access and modify the state (CommentData) of the Comment entity within the Article aggregate

//import { CommentSeqIdGenerator } from "../codegen/index.sol";
// You may need to use the CommentSeqIdGenerator library to generate the Id of the Comment entity within the Article aggregate
//
// You can get and update the sequence Id of Comment like this:
//    uint64 articleId;
//    uint64 commentSeqId = CommentSeqIdGenerator.get(articleId) + 1;
//    CommentSeqIdGenerator.set(articleId, commentSeqId);

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
    string memory commenter,
    string memory body,
    ArticleData memory articleData
  ) internal pure returns (CommentAdded memory) {
    // If necessary, change state mutability modifier of the function from `pure` to `view` or just delete `pure`.
    //
    // Note: Do not arbitrarily add parameters to functions or fields to structs.
    //
    // The message sender can be obtained like this: `WorldContextConsumerLib._msgSender()`
    //
    // TODO: Check arguments, throw if illegal.
    /*
    return CommentAdded({
      id: // type: uint64
      commentSeqId: // type: uint64
      commenter: // type: string
      body: // type: string
    });
    */
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
  ) internal pure returns (ArticleData memory) {
    // If necessary, change state mutability modifier of the function from `pure` to `view` or just delete `pure`.

    // NOTE: The Comment entity is managed separately.
    // The actual storage of the Comment (CommentData) would be handled by the Comment library.
    // Note: Functions cannot be declared as pure or view if you modify the state of the Comment entity.

    //
    // The fields (types and names) of the struct CommentData:
    //   string commenter
    //   string body
    //

    // NOTE: The ArticleTag entity is managed separately.
    // The actual storage of the ArticleTag (string) would be handled by the ArticleTagLib library.
    // Note: Functions cannot be declared as pure or view if you modify the state of the ArticleTag entity.

    //
    // The fields (types and names) of the struct ArticleData:
    //   address author
    //   string title
    //   string body
    //

    // TODO: update state properties...
    //articleData.{STATE_PROPERTY} = commentAdded.{EVENT_PROPERTY};
    return articleData;
  }
}
