// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { ArticleTag, ArticleTagCount } from "../codegen/index.sol";

library ArticleTagLib {
  function addTag(uint64 articleId, string memory tag) internal {
    uint64 count = ArticleTagCount.get(articleId);
    ArticleTag.set(articleId, count, tag);
    ArticleTagCount.set(articleId, count + 1);
  }

  function removeLastTag(uint64 articleId) internal {
    uint64 count = ArticleTagCount.get(articleId);
    require(count > 0, "No tags to remove");
    ArticleTagCount.set(articleId, count - 1);
    ArticleTag.deleteRecord(articleId, count - 1);
  }

  function insertTag(uint64 articleId, uint64 index, string memory tag) internal {
    uint64 count = ArticleTagCount.get(articleId);
    require(index <= count, "Invalid index");

    for (uint64 i = count; i > index; i--) {
      ArticleTag.set(articleId, i, ArticleTag.get(articleId, i - 1));
    }

    ArticleTag.set(articleId, index, tag);
    ArticleTagCount.set(articleId, count + 1);
  }

  function removeTag(uint64 articleId, uint64 index) internal {
    uint64 count = ArticleTagCount.get(articleId);
    require(index < count, "Invalid index");

    for (uint64 i = index; i < count - 1; i++) {
      ArticleTag.set(articleId, i, ArticleTag.get(articleId, i + 1));
    }

    ArticleTag.deleteRecord(articleId, count - 1);
    ArticleTagCount.set(articleId, count - 1);
  }

  function updateTag(uint64 articleId, uint64 index, string memory tag) internal {
    uint64 count = ArticleTagCount.get(articleId);
    require(index < count, "Invalid index");
    ArticleTag.set(articleId, index, tag);
  }

  function getAllTags(uint64 articleId) internal view returns (string[] memory) {
    uint64 count = ArticleTagCount.get(articleId);
    string[] memory tags = new string[](count);
    for (uint64 i = 0; i < count; i++) {
      tags[i] = ArticleTag.get(articleId, i);
    }
    return tags;
  }
}
