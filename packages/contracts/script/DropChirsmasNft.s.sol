// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "forge-std/Script.sol";
import "../src/tokens/ChristmasNFT.sol"; // 导入合约

contract DropChirsmasNft is Script {
  //
  // forge script DropChirsmasNft.s.sol:DropChirsmasNft --sig "run(address)" 0x593ad505023ea24371f8f628b251e0667308840f --broadcast --rpc-url https://odyssey.storyrpc.io/
  // forge script DropChirsmasNft.s.sol:DropChirsmasNft --broadcast --rpc-url https://odyssey.storyrpc.io/
  //
  function run() external {
    // Load the private key from the `PRIVATE_KEY` environment variable (in .env)
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    address deployerAddress = vm.addr(deployerPrivateKey);

    // Start broadcasting transactions from the deployer account
    vm.startBroadcast(deployerPrivateKey);

    console.log("Current account:", deployerAddress);

    uint256 balance = deployerAddress.balance;
    console.log("Account balance:", balance);
    // ************************************************************************************************
    ChristmasNFT christmasNFT = new ChristmasNFT(deployerAddress);
    address christmasNFTAddress = address(christmasNFT);
    console.log("ChristmasNFT contract address:%s", christmasNFTAddress);
    address[] memory recipients = new address[](2);
    recipients[0] = address(0x79785B77EE18F14BcE7006d9583D26279A39bAF7);
    recipients[1] = address(0x8D99E71D8b216038bc114D43E96Ca2028ef70fA6);
    string[] memory tokenURIs = new string[](2);
    tokenURIs[0] = "https://www.baidu.com/img/PCfb_5bf082d29588c07f842ccde3f97243ea.png";
    tokenURIs[1] = "https://pbs.twimg.com/media/GcO4FfObUAA4alp?format=jpg";
    AirdropInfo[] memory airdropInfos = christmasNFT.airdrop(recipients, tokenURIs);
    for (uint i = 0; i < airdropInfos.length; i++) {
      console.log(
        "Recipient address: %s,  tokenURI: %s,  tokenId: %d",
        airdropInfos[i].recipient,
        airdropInfos[i].tokenURI,
        airdropInfos[i].tokenId
      );
    }

    vm.stopBroadcast();
  }
}
