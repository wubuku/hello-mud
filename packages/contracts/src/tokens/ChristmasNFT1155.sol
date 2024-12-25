// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ChristmasNFT1155 is ERC1155, Ownable {
  using Strings for uint256;

  uint256 public constant LEGENDARY = 1;
  uint256 public constant RARE = 2;

  constructor(
    address initialOwner
  )
    ERC1155("http://ec2-18-236-242-218.us-west-2.compute.amazonaws.com:8097/christmas_nft/{id}.json")
    Ownable(initialOwner)
  {
    // _mint(msg.sender, COMMON, 7000, "");
    // _mint(msg.sender, RARE, 2500, "");
    // _mint(msg.sender, LEGENDARY, 500, "");
  }

  function uri(uint256 id) public pure override returns (string memory) {
    // 根据代币 ID 返回相应的 URI
    return
      string(
        abi.encodePacked(
          "http://ec2-18-236-242-218.us-west-2.compute.amazonaws.com:8097/christmas_nft/",
          id.toString(),
          ".json"
        )
      );
  }

  function airdrop(address[] calldata recipients, uint256 id, uint256 amount) external onlyOwner {
    for (uint256 i = 0; i < recipients.length; i++) {
      _mint(recipients[i], id, amount, "");
    }
  }
}
