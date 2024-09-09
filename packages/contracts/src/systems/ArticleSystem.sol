// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ArticleAggregate } from "./ArticleAggregate.sol";
// import { ArticleData } from "../codegen/index.sol";

contract ArticleSystem is ArticleAggregate {
  function articleAddTag(uint64 id, string memory tag) public override {
    // ArticleData memory articleData = Article.get(id);
    // require(articleData.author == ctx._msgSender(), "Not the author");
    super.articleAddTag(id, tag);
  }

  function articleCreate(address author, string memory title, string memory body) public override {
    super.articleCreate(author, title, body);
  }

  function articleUpdate(uint64 id, address author, string memory title, string memory body) public override {
    super.articleUpdate(id, author, title, body);
  }

  function articleDelete(uint64 id) public override {
    super.articleDelete(id);
  }
}
