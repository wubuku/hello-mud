// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ArticleUpdated } from "./ArticleEvents.sol";
import { ArticleData } from "../codegen/index.sol";

library ArticleUpdateLogic {
  function verify(
    uint64 id,
    address author,
    string memory title,
    string memory body,
    ArticleData memory articleData
  ) internal pure returns (ArticleUpdated memory) {
    return ArticleUpdated(id, author, title, body);
  }

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
