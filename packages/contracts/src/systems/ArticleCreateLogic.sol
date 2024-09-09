// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ArticleCreated } from "./ArticleEvents.sol";
import { ArticleData } from "../codegen/index.sol";
import { IWorldContextConsumer } from "@latticexyz/world/src/IWorldContextConsumer.sol";

library ArticleCreateLogic {
  function verify(
    uint64 id,
    address author,
    string memory title,
    string memory body
  ) internal view returns (ArticleCreated memory) {

    // Get the MUD context information this way:
    IWorldContextConsumer ctx = IWorldContextConsumer(address(this));
    address _author = ctx._msgSender();

    return ArticleCreated(id, _author, title, body);
  }

  function mutate(
    ArticleCreated memory articleCreated
  ) internal pure returns (ArticleData memory) {
    ArticleData memory articleData;
    articleData.author = articleCreated.author;
    articleData.title = articleCreated.title;
    articleData.body = articleCreated.body;
    return articleData;
  }
}
