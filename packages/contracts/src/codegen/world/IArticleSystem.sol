// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

/**
 * @title IArticleSystem
 * @author MUD (https://mud.dev) by Lattice (https://lattice.xyz)
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IArticleSystem {
  function app__articleAddTag(uint64 id, string memory tag) external;

  function app__articleCreate(address author, string memory title, string memory body) external;

  function app__articleUpdate(uint64 id, address author, string memory title, string memory body) external;

  function app__articleDelete(uint64 id) external;

  function app__articleAddComment(uint64 id, string memory commenter, string memory body) external;

  function app__articleUpdateComment(
    uint64 id,
    uint64 commentSeqId,
    string memory commenter,
    string memory body
  ) external;

  function app__articleRemoveComment(uint64 id, uint64 commentSeqId) external;
}
