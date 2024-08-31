// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ArticleDeleted } from "./ArticleEvents.sol";
import { ArticleData } from "../codegen/index.sol";

library ArticleDeleteLogic {
  function verify(
    uint64 id,
    ArticleData memory articleData
  ) internal pure returns (ArticleDeleted memory) {
    articleData.author; // silence the warning
    return ArticleDeleted(id);
  }

  function mutate(
    ArticleDeleted memory articleDeleted,
    ArticleData memory articleData
  ) internal pure returns (ArticleData memory) {
    articleDeleted.id; // silence the warning
    return articleData;
  }
}
