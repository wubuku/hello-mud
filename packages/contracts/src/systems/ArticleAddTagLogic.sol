// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { TagAdded } from "./ArticleEvents.sol";
import { ArticleData } from "../codegen/index.sol";
import { ArticleTagLib } from "./ArticleTagLib.sol";
import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";

library ArticleAddTagLogic {
  function verify(
    uint64 id,
    string memory tag,
    ArticleData memory articleData
  ) internal view returns (TagAdded memory) {

    require(articleData.author == WorldContextConsumerLib._msgSender(), "Not the author");

    string[] memory tags = ArticleTagLib.getAllTags(id);
    for (uint i = 0; i < tags.length; i++) {
      require(keccak256(bytes(tags[i])) != keccak256(bytes(tag)), "Tag already exists");
      //require(!Strings.equal(tags[i], tag), "Tag already exists");
    }
    return TagAdded(id, tag);
  }

  function mutate(
    TagAdded memory tagAdded,
    ArticleData memory articleData
  ) internal returns (ArticleData memory) {
    uint64 articleId = tagAdded.id;
    ArticleTagLib.addTag(articleId, tagAdded.tag);
    return articleData;
  }
}
