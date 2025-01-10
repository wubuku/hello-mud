// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import "forge-std/Script.sol";
import "../src/tokens/ChristmasNFT721Legendary.sol";

contract DropChristmasNFT721Legendary is Script {
  //
  // forge script DropChirsmasNft.s.sol:DropChirsmasNft --sig "run(address)" 0x593ad505023ea24371f8f628b251e0667308840f --broadcast --rpc-url https://odyssey.storyrpc.io/
  // forge script DropChristmasNFT721Legendary.s.sol:DropChristmasNFT721Legendary --broadcast --rpc-url https://odyssey.storyrpc.io/
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
    ChristmasNFT721Legendary christmasNFT = new ChristmasNFT721Legendary(deployerAddress);
    address christmasNFTAddress = address(christmasNFT);
    console.log("ChristmasNFT contract address:%s", christmasNFTAddress);
    // address[] memory walletAddresses = new address[](100);
    // walletAddresses[0] = address(0xfF7fe4D65eF0721a144B4615f254e7Bc74cc6b92);
    // walletAddresses[1] = address(0x0597BbAdc94E95ec542C3DDcA8adc0785Ca7FBC0);
    // walletAddresses[2] = address(0xB4fBfa34cE1Ed98584EAB72079639C175B4a0A49);
    // walletAddresses[3] = address(0xf25bf45f265C8eb3Bb9af6b3CE8E0B429CFe5274);
    // walletAddresses[4] = address(0x8F2017f41fBF2af9e0AFD3630F805FE7Caf91F2e);
    // walletAddresses[5] = address(0xd83f76f728e0BbBbaEF7f0345cd8A1186AA94bC3);
    // walletAddresses[6] = address(0xfd55bb0A03858936b936cB55809f7BaC3d633b49);
    // walletAddresses[7] = address(0xC92bDEEc2A26e908922400117B6E627B494eA2CD);
    // walletAddresses[8] = address(0xB046B534aCa08C09A34377770214812dF81e97ba);
    // walletAddresses[9] = address(0x200730fA35bA24BDed34f5BA3D0fbe7C2793CC7d);
    // walletAddresses[10] = address(0x5806Ed580d58FfB5C8998E96BA8632DAc10d651A);
    // walletAddresses[11] = address(0x9B0DF7efbAF26d5D30Cb971701ce65c156a412B8);
    // walletAddresses[12] = address(0xfa6c4421FE5015cFc24b38eC7c69Df0643B9ee0A);
    // walletAddresses[13] = address(0x5eC1B4b5dc6F3493B9b692FC6d1Ff9e4bf699C16);
    // walletAddresses[14] = address(0xe91f3771EC04de08bddE01D9e78428b50e8fB111);
    // walletAddresses[15] = address(0x8d71924BE0b17a8d37eA737B57430a899450F860);
    // walletAddresses[16] = address(0x265c9e24EE81aB9FccE804305abae6260e8220b1);
    // walletAddresses[17] = address(0x2dC5332A76374fcAA9fB10BfCE86b4C8E10c1387);
    // walletAddresses[18] = address(0x2196AEF887278d7574FB92685Ad81b6B9BFEFD01);
    // walletAddresses[19] = address(0xd2Ea1FB4977ba6e765D63c4d5Fb255f48b4630dD);
    // walletAddresses[20] = address(0x00c9d03eadd30ce9725691B6f845D99A9c31BB2b);
    // walletAddresses[21] = address(0x82cD80cEe3E990eF869Ce1675DBDD29574881632);
    // walletAddresses[22] = address(0xD74365863774e566Ee2De92C63329c9f9BFa59D5);
    // walletAddresses[23] = address(0x460cff2BBc99e23Dcc3Ab8C58605857c11f6B214);
    // walletAddresses[24] = address(0xF925Ad44e577CA721Fa161489b1e089cA0db036C);
    // walletAddresses[25] = address(0xBbBa104837C7d893Fa2EA6a0E28D9d270469b8A5);
    // walletAddresses[26] = address(0x2f4C868838D37837Ed3dDfFEee3332019d6f7E7d);
    // walletAddresses[27] = address(0xe2657A1eae1792cCbDE4c4eb51bF7869415ECa46);
    // walletAddresses[28] = address(0x95108692A0691c75DB875559407A0C321dFf051f);
    // walletAddresses[29] = address(0x1c0Dbb093885DC788cD62938C3D10F21D13133C9);
    // walletAddresses[30] = address(0x2940ac02538F09C88a07d7e7C120780521367367);
    // walletAddresses[31] = address(0xaeCE1977aB5062277681906D8b6601a34d94c64c);
    // walletAddresses[32] = address(0xb6A21258b7A9ea5E5844fEB4947C89d5995262b1);
    // walletAddresses[33] = address(0xAC5B09f438b6180A509c5f5F242f332439319dA2);
    // walletAddresses[34] = address(0xf35ec456867ae55040B8DBb6eE055bDAdAE6b5Ca);
    // walletAddresses[35] = address(0x03E5BadF3bB1ADe1a8F33f94536c827b6531948d);
    // walletAddresses[36] = address(0x6966fDede21643b743E1096aCc4BE81a922981b7);
    // walletAddresses[37] = address(0x6eC55aBccd5AC690806acb78e0A063f36A594895);
    // walletAddresses[38] = address(0xB7878CB4276317dD1E7b2f60db7b08e3B9e5E705);
    // walletAddresses[39] = address(0x34222e9e32f35E36A542522Bf182F11b983145fF);
    // walletAddresses[40] = address(0x25e5E6b9FaD64Fb5e2286DcCE60234ad02dCEDe8);
    // walletAddresses[41] = address(0x691aB1859560408E5d460fa21E7Bce90529DFcDA);
    // walletAddresses[42] = address(0x6b5229a0C800cF4e592CeADFc8a26CB29C5438c6);
    // walletAddresses[43] = address(0xB0E8C6fD161164dbbFbda8091B8040412996b757);
    // walletAddresses[44] = address(0xA2E32C9D6f299c25A281cb62ec55d66B48398C0F);
    // walletAddresses[45] = address(0x6E1fDDd19848fdC02217609d1Ae731D8017bE56F);
    // walletAddresses[46] = address(0x17E6E05EA6B6054Db3BFC6E25FA4F8CDd4F31675);
    // walletAddresses[47] = address(0x962c637Da54577B64Ed50bF091643c3C4d70202D);
    // walletAddresses[48] = address(0xe96892fF1D85338107EcA40941A5CE3b871EAA6A);
    // walletAddresses[49] = address(0x88D452559a9f0B8f3481F652d16780De7b682E4c);
    // walletAddresses[50] = address(0xB94835172b8321bC98624815944248Fd9E9B6c2f);
    // walletAddresses[51] = address(0x9bA150561c80B8Dd5BbA76491E1aafaeca4f8fc7);
    // walletAddresses[52] = address(0xb626792a706e62263fe08b828C2f90aD4ef34601);
    // walletAddresses[53] = address(0xd7A5Ea9E8C52Bfc1f78B50ad225331e1C9139F1e);
    // walletAddresses[54] = address(0x733A2C9C576B1056b2161640D0aE7FCCee27eC71);
    // walletAddresses[55] = address(0x7486F07F0Ce4e2A006b3D780F4A018202d958637);
    // walletAddresses[56] = address(0xa5877FA81ecc3D8a3f97a14334D848C273b4A863);
    // walletAddresses[57] = address(0x1A8d8Baed2161e145686d20e579775C8ca032216);
    // walletAddresses[58] = address(0xDFBd90f052d556c8FB97Ab9232Ea437022ACc4A3);
    // walletAddresses[59] = address(0x44CBf98851AcB26Aeb807C9dD5B8646fca6c7E7f);
    // walletAddresses[60] = address(0x32A637C3B8C44D8F3870DC313f5D715b6AfF6A69);
    // walletAddresses[61] = address(0xD8A080dB0557C6882f3e718A0d492FE2A80Dc493);
    // walletAddresses[62] = address(0x0f3722728f9C44418e674788E9f9e85462de0d34);
    // walletAddresses[63] = address(0x0f0aBa0710AD81E74EfA24Ceb1e944f089c99138);
    // walletAddresses[64] = address(0xdbBc16eC59E3fdC4b63Ae057e7723Ca2A6f0b719);
    // walletAddresses[65] = address(0x164a8379198a8d7155a1F0eaB9BAA256078d378E);
    // walletAddresses[66] = address(0xb154cf54abe4a85C120D3B0A6393ee7D5e63d5E1);
    // walletAddresses[67] = address(0x487226E99F143A33C5CFf4E18c04376Db8e67420);
    // walletAddresses[68] = address(0x79785B77EE18F14BcE7006d9583D26279A39bAF7);
    // walletAddresses[69] = address(0x7148092b512df4751826577E26cD170B69F88400);
    // walletAddresses[70] = address(0xD99481Ed205f3afF869d3508abc7042101Ec4934);
    // walletAddresses[71] = address(0xc6EFdB57b3E5E3958e40362FAc8dff6d7895093C);
    // walletAddresses[72] = address(0x3c66Bb9C32954C189D473e80448B54FA3d092554);
    // walletAddresses[73] = address(0x944767B324D8e82DA56608BA62E857CeD15e7E18);
    // walletAddresses[74] = address(0x571feBf680a9fd637a9AE76587427bcef048f5E0);
    // walletAddresses[75] = address(0x716a33adb72ff53B91765698229Ac74863bE41DA);
    // walletAddresses[76] = address(0x9c8eE61558Cf45b69Be055663EDFC8b33c4D0B42);
    // walletAddresses[77] = address(0xeFEEec518F6C7cAcF0386D92ca8f739c48418E81);
    // walletAddresses[78] = address(0x1dbd83b641993725360F7436881964bf4c73198E);
    // walletAddresses[79] = address(0xb6Eb414950d92350CF39989bAC3Fffe9aF604774);
    // walletAddresses[80] = address(0xfFc67D03FfA1e54abD3c730e5a3FbC53d0F9Cb1b);
    // walletAddresses[81] = address(0xe3AaF356F3933916CBC3550d9337dA591c69f8d6);
    // walletAddresses[82] = address(0x4bE8A7C88b8d1d947d8F410E4e3Cf4B13Dc17250);
    // walletAddresses[83] = address(0xA991bB21581Df80a131F22138cAD607035D722d6);
    // walletAddresses[84] = address(0x773B1aCC268f8A0C6076752FcC042BaB87597718);
    // walletAddresses[85] = address(0xC4d1e22E995870ECA6BE63e34294337A351C9D76);
    // walletAddresses[86] = address(0xFC5f39AA7934E39a45564DA3Ec53D94fd7FF06b2);
    // walletAddresses[87] = address(0xb79840074e023e2fDB558E068FFCE119628b1242);
    // walletAddresses[88] = address(0xAa8DCef16b82c04D65fBfa29403f3000B9E398Ab);
    // walletAddresses[89] = address(0x6E98908Ffd0C837B7dEb0Ac949300b6C60791228);
    // walletAddresses[90] = address(0x7F163D66C5d395FC0Ea2cacC49cb1893b64d8E4d);
    // walletAddresses[91] = address(0x8AD51CD87ECfc95629B058D318a5049c8FCDAe7F);
    // walletAddresses[92] = address(0x12D143Fbc25b54B5a6A02CCA1C63A0Fc630104de);
    // walletAddresses[93] = address(0x3504a7abF0085Df70ebf5B5A6D73BFACe389aDC7);
    // walletAddresses[94] = address(0xF57002f852177127bB448960EfCf49d776f3001E);
    // walletAddresses[95] = address(0x511C3410FE6a60369610fCA7F081E72533049714);
    // walletAddresses[96] = address(0xACdf13E7C0C075a5e61C4532AbD6B1eE508B22b2);
    // walletAddresses[97] = address(0x20C22dC5022Aeabbd30c8b594bfd44fB167abE70);
    // walletAddresses[98] = address(0x3cdD07924D746b5f32550031BA2C94b86013F86C);
    // walletAddresses[99] = address(0x967dbE00451F36DA86440Fba9bf92Fc8bF446f33);
    address[] memory walletAddresses = new address[](1);
    walletAddresses[0] = address(0x20C22dC5022Aeabbd30c8b594bfd44fB167abE70);
    string[] memory tokenURIs = new string[](walletAddresses.length);
    for (uint i = 0; i < tokenURIs.length; i++) {
      tokenURIs[i] = "http://ec2-18-236-242-218.us-west-2.compute.amazonaws.com:8097/christmas_nft/1.json";
    }
    AirdropInfo[] memory airdropInfos = christmasNFT.airdrop(walletAddresses, tokenURIs);
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
