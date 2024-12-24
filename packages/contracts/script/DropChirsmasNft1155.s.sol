// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "forge-std/Script.sol";
import "../src/tokens/ChristmasNFT1155.sol"; // 导入合约

contract DropChirsmasNft1155 is Script {
  uint256 public constant COMMON = 0;
  uint256 public constant RARE = 1;
  uint256 public constant LEGENDARY = 2;
  //
  // forge script DropChirsmasNft1155.s.sol:DropChirsmasNft1155 --sig "run(address)" 0x593ad505023ea24371f8f628b251e0667308840f --broadcast --rpc-url https://odyssey.storyrpc.io/
  // forge script DropChirsmasNft1155.s.sol:DropChirsmasNft1155 --broadcast --rpc-url https://odyssey.storyrpc.io/
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
    ChristmasNFT1155 christmasNFT = new ChristmasNFT1155(deployerAddress);
    address christmasNFTAddress = address(christmasNFT);
    console.log("ChristmasNFT contract address:%s", christmasNFTAddress);
    address[] memory recipients = new address[](4);
    recipients[0] = address(0x79785B77EE18F14BcE7006d9583D26279A39bAF7);
    recipients[1] = address(0x8D99E71D8b216038bc114D43E96Ca2028ef70fA6);
    recipients[2] = address(0xe0e2F59e187546985964596407afF445EE4304c3);
    recipients[3] = address(0x20C22dC5022Aeabbd30c8b594bfd44fB167abE70);
    christmasNFT.airdrop(recipients, RARE, 1);
    vm.stopBroadcast();
  }
}
