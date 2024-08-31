// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { System } from "@latticexyz/world/src/System.sol";
import { Article, ArticleData, ArticleIdGenerator } from "../codegen/index.sol";
import { ArticleCreated, ArticleUpdated, ArticleDeleted } from "./ArticleEvents.sol";
import { ArticleCreateLogic } from "./ArticleCreateLogic.sol";
import { ArticleUpdateLogic } from "./ArticleUpdateLogic.sol";
import { ArticleDeleteLogic } from "./ArticleDeleteLogic.sol";

contract ArticleSystem is System {
  event ArticleCreatedEvent(uint64 indexed id, address author, string title, string body);

  event ArticleUpdatedEvent(uint64 indexed id, address author, string title, string body);

  event ArticleDeletedEvent(uint64 indexed id);

  function articleCreate(address author, string memory title, string memory body) public {
    uint64 id = ArticleIdGenerator.get() + 1;
    ArticleIdGenerator.set(id);
    ArticleData memory articleData = Article.get(id);
    require(
      articleData.author == address(0) && bytes(articleData.title).length == 0 && bytes(articleData.body).length == 0,
      "Article already exists"
    );
    ArticleCreated memory articleCreated = ArticleCreateLogic.verify(id, author, title, body);
    articleCreated.id = id;
    emit ArticleCreatedEvent(articleCreated.id, articleCreated.author, articleCreated.title, articleCreated.body);
    ArticleData memory newArticleData = ArticleCreateLogic.mutate(articleCreated);
    Article.set(id, newArticleData);
  }

  function articleUpdate(uint64 id, address author, string memory title, string memory body) public {
    ArticleData memory articleData = Article.get(id);
    require(
      !(articleData.author == address(0) && bytes(articleData.title).length == 0 && bytes(articleData.body).length == 0),
      "Article does not exist"
    );
    ArticleUpdated memory articleUpdated = ArticleUpdateLogic.verify(id, author, title, body, articleData);
    emit ArticleUpdatedEvent(articleUpdated.id, articleUpdated.author, articleUpdated.title, articleUpdated.body);
    ArticleData memory updatedArticleData = ArticleUpdateLogic.mutate(articleUpdated, articleData);
    Article.set(id, updatedArticleData);
  }

  function articleDelete(uint64 id) public {
    ArticleData memory articleData = Article.get(id);
    require(
      !(articleData.author == address(0) && bytes(articleData.title).length == 0 && bytes(articleData.body).length == 0),
      "Article does not exist"
    );
    ArticleDeleted memory articleDeleted = ArticleDeleteLogic.verify(id, articleData);
    emit ArticleDeletedEvent(articleDeleted.id);
    ArticleData memory updatedArticleData = ArticleDeleteLogic.mutate(articleDeleted, articleData);
    Article.set(id, updatedArticleData);
  }

}