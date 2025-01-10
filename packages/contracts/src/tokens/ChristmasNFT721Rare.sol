// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

struct AirdropInfo {
  address recipient;
  string tokenURI;
  uint256 tokenId;
}
contract ChristmasNFT721Rare is ERC721URIStorage, Ownable {
  uint256 public nextTokenId = 1;

  event Minted(address indexed to, uint256 tokenId, string tokenURI);
  //event Airdropped(address[] recipients, string[] tokenURIs);

  constructor(address initialOwner) ERC721("Christmas Special Sailors", "CSS") Ownable(initialOwner) {}

  function mint(address to, string calldata tokenURI) public onlyOwner returns (AirdropInfo memory) {
    _safeMint(to, nextTokenId);
    _setTokenURI(nextTokenId, tokenURI);
    emit Minted(to, nextTokenId, tokenURI);
    AirdropInfo memory newAirdropInfo = AirdropInfo(to, tokenURI, nextTokenId);
    nextTokenId++;
    return newAirdropInfo;
  }

  //   function tokenURI(uint256 _tokenId) public view returns (string) {
  //     return string.concat(baseTokenURI(), Strings.uint2str(_tokenId));
  //   }

  function airdrop(
    address[] calldata recipients,
    string[] calldata tokenURIs
  ) public onlyOwner returns (AirdropInfo[] memory) {
    require(recipients.length == tokenURIs.length, "Recipients and URIs length mismatch");
    AirdropInfo[] memory airdropInfos = new AirdropInfo[](recipients.length);
    for (uint256 i = 0; i < recipients.length; i++) {
      airdropInfos[i] = mint(recipients[i], tokenURIs[i]);
    }
    //emit Airdropped(recipients, tokenURIs);
    return airdropInfos;
  }
}
