// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";

import { IWorld } from "../src/codegen/world/IWorld.sol";
import { ItemIdQuantityPair } from "../src/systems/ItemIdQuantityPair.sol";
import { AccountPlayer, PlayerData, Player } from "../src/codegen/index.sol";
// We need to create the ResourceID for the System we are calling
import { ResourceId, WorldResourceIdLib, WorldResourceIdInstance } from "@latticexyz/world/src/WorldResourceId.sol";
import { RESOURCE_SYSTEM } from "@latticexyz/world/src/worldResourceTypes.sol";

import { SystemCallData } from "@latticexyz/world/src/modules/init/types.sol";

//批量添加岛屿（使用Batchcall一个个添加） forge script BatchAirDropToIslands.s.sol:BatchCall --sig "run(address)" 0x63381030dda22c888f2548436c73146ef835ab9e --broadcast --rpc-url https://odyssey.storyrpc.io/
contract BatchCall is Script {
  //Item ids
  uint32 constant UNUSED_ITEM_ID = 0;
  uint32 constant POTATO_SEEDS_ITEM_ID = 1;
  uint32 constant POTATOES_ITEM_ID = 101;
  uint32 constant COTTON_SEEDS_ITEM_ID = 2;
  uint32 constant COTTONS_ITEM_ID = 102;
  uint32 constant BRONZE_BAR_ITEM_ID = 1001;
  uint32 constant NORMAL_LOGS_ITEM_ID = 200;
  uint32 constant OAK_LOGS_ITEM_ID = 201;
  uint32 constant SHIP_ITEM_ID = 1000000001;
  uint32 constant FLUYT_ITEM_ID = 1000000002;
  uint32 constant COPPER_ORE_ITEM_ID = 301;
  uint32 constant TIN_ORE_ITEM_ID = 302;
  uint32 constant MINION_ITEM_ID = 401;
  uint32 constant SMALL_SAIL_ITEM_ID = 402;
  uint32 constant RESOURCE_TYPE_WOODCUTTING_ITEM_ID = 2000000001;
  uint32 constant RESOURCE_TYPE_FISHING_ITEM_ID = 2000000002;
  uint32 constant RESOURCE_TYPE_MINING_ITEM_ID = 2000000003;

  //Quantity weights

  uint32 resourceWoodCuttingQuantity = 200;
  uint32 resourceMinningQuantity = 200;
  uint32 resoucePotatoSeedsQuantity = 200;
  uint32 resouceCottonSeedsQuantity = 200;
  function run(address worldAddress) external {
    StoreSwitch.setStoreAddress(worldAddress);
    //IWorld world = IWorld(worldAddress);

    // Load the private key from the `PRIVATE_KEY` environment variable (in .env)
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

    // Start broadcasting transactions from the deployer account
    vm.startBroadcast(deployerPrivateKey);

    ResourceId systemId = WorldResourceIdLib.encode({
      typeId: RESOURCE_SYSTEM,
      namespace: "app",
      name: "MapSystem" //mapAddIsland方法所在的合约的名称的前16位
    });

    address[] memory walletAddresses = new address[](400);
    walletAddresses[0] = address(0x2B8A39A376f40884b5B78dA1339e63777BEa2a17);
    walletAddresses[1] = address(0xA2E32C9D6f299c25A281cb62ec55d66B48398C0F);
    walletAddresses[2] = address(0xfF7fe4D65eF0721a144B4615f254e7Bc74cc6b92);
    walletAddresses[3] = address(0x95108692A0691c75DB875559407A0C321dFf051f);
    walletAddresses[4] = address(0x00c9d03eadd30ce9725691B6f845D99A9c31BB2b);
    walletAddresses[5] = address(0xD74365863774e566Ee2De92C63329c9f9BFa59D5);
    walletAddresses[6] = address(0x329C2b0fef94881433BA7c714E3d2b620691549a);
    walletAddresses[7] = address(0xf25bf45f265C8eb3Bb9af6b3CE8E0B429CFe5274);
    walletAddresses[8] = address(0x154a309479E3CC5B40A363a419262601b9502B40);
    walletAddresses[9] = address(0x7F163D66C5d395FC0Ea2cacC49cb1893b64d8E4d);
    walletAddresses[10] = address(0x01A1E872212AfaC16218371d4F9d25F3178b98D8);
    walletAddresses[11] = address(0xaeCE1977aB5062277681906D8b6601a34d94c64c);
    walletAddresses[12] = address(0x460cff2BBc99e23Dcc3Ab8C58605857c11f6B214);
    walletAddresses[13] = address(0x733A2C9C576B1056b2161640D0aE7FCCee27eC71);
    walletAddresses[14] = address(0x5eC1B4b5dc6F3493B9b692FC6d1Ff9e4bf699C16);
    walletAddresses[15] = address(0xe2657A1eae1792cCbDE4c4eb51bF7869415ECa46);
    walletAddresses[16] = address(0x967dbE00451F36DA86440Fba9bf92Fc8bF446f33);
    walletAddresses[17] = address(0xD99481Ed205f3afF869d3508abc7042101Ec4934);
    walletAddresses[18] = address(0x9c8eE61558Cf45b69Be055663EDFC8b33c4D0B42);
    walletAddresses[19] = address(0x057c1cFbC71d946d9E2eE05B2a30b74f9aD2eB71);
    walletAddresses[20] = address(0xdbBc16eC59E3fdC4b63Ae057e7723Ca2A6f0b719);
    walletAddresses[21] = address(0xF925Ad44e577CA721Fa161489b1e089cA0db036C);
    walletAddresses[22] = address(0x164a8379198a8d7155a1F0eaB9BAA256078d378E);
    walletAddresses[23] = address(0xBbBa104837C7d893Fa2EA6a0E28D9d270469b8A5);
    walletAddresses[24] = address(0xaEC89877261a1959174D225D14cCdAEE8098662d);
    walletAddresses[25] = address(0x4B6d0854Ee25E7F38b0A1CFcb7A1Ded06a30Cc69);
    walletAddresses[26] = address(0x29e4797dce5aEBF92473719098ABD9649f3e5879);
    walletAddresses[27] = address(0xd41F13814dfBB7E3d622af2eCbDE0b368c054676);
    walletAddresses[28] = address(0x8bd3C4837300B5009d38294838686030fd6ABaC9);
    walletAddresses[29] = address(0x8AD51CD87ECfc95629B058D318a5049c8FCDAe7F);
    walletAddresses[30] = address(0x0597BbAdc94E95ec542C3DDcA8adc0785Ca7FBC0);
    walletAddresses[31] = address(0x40421E27480caf8FcbB7cDd6424C4A9b4AC02f73);
    walletAddresses[32] = address(0xB974536a3125cEBB243B1DfD118d5668dD40e418);
    walletAddresses[33] = address(0x6eC55aBccd5AC690806acb78e0A063f36A594895);
    walletAddresses[34] = address(0xe91f3771EC04de08bddE01D9e78428b50e8fB111);
    walletAddresses[35] = address(0x7B2D1556d243eE1DD1060c2Fa2955926Dee208a6);
    walletAddresses[36] = address(0xD8A080dB0557C6882f3e718A0d492FE2A80Dc493);
    walletAddresses[37] = address(0xB4fBfa34cE1Ed98584EAB72079639C175B4a0A49);
    walletAddresses[38] = address(0xACdf13E7C0C075a5e61C4532AbD6B1eE508B22b2);
    walletAddresses[39] = address(0x1A8d8Baed2161e145686d20e579775C8ca032216);
    walletAddresses[40] = address(0x24FeE70E5940e9B211DE8089B09C307921258eEF);
    walletAddresses[41] = address(0x1Eb18844ab577B5ad6FF35D1B6412839a4dCdf31);
    walletAddresses[42] = address(0x8ce33f8BF0b2E5356636B025654594e1efffd8BF);
    walletAddresses[43] = address(0x2dC5332A76374fcAA9fB10BfCE86b4C8E10c1387);
    walletAddresses[44] = address(0xa02530ec95F9acD8ac901B46f99032E702be3F04);
    walletAddresses[45] = address(0x79785B77EE18F14BcE7006d9583D26279A39bAF7);
    walletAddresses[46] = address(0xe96892fF1D85338107EcA40941A5CE3b871EAA6A);
    walletAddresses[47] = address(0xacCaAAe9a153bACEA2Ded2E224046BC7382E6FAd);
    walletAddresses[48] = address(0x64d65E1c4f2e70dC1114f14C6505678C048dA7ec);
    walletAddresses[49] = address(0x716a33adb72ff53B91765698229Ac74863bE41DA);
    walletAddresses[50] = address(0xAC5B09f438b6180A509c5f5F242f332439319dA2);
    walletAddresses[51] = address(0xcBA0bec48D1Ab190A2db94409f78bf3BB5c46a0F);
    walletAddresses[52] = address(0x28248c3fb91971B46fe4a8Fe849D48478193DB7c);
    walletAddresses[53] = address(0x4bE8A7C88b8d1d947d8F410E4e3Cf4B13Dc17250);
    walletAddresses[54] = address(0x0f7B9b0A9E86cF56c9C3ae9dD1b7c77ab60F2EED);
    walletAddresses[55] = address(0x8F2017f41fBF2af9e0AFD3630F805FE7Caf91F2e);
    walletAddresses[56] = address(0x571feBf680a9fd637a9AE76587427bcef048f5E0);
    walletAddresses[57] = address(0xfd55bb0A03858936b936cB55809f7BaC3d633b49);
    walletAddresses[58] = address(0xd7A5Ea9E8C52Bfc1f78B50ad225331e1C9139F1e);
    walletAddresses[59] = address(0xa5877FA81ecc3D8a3f97a14334D848C273b4A863);
    walletAddresses[60] = address(0xb57e52d32A4D3ebDe546C20818C0B989E9c0a1C5);
    walletAddresses[61] = address(0xC92bDEEc2A26e908922400117B6E627B494eA2CD);
    walletAddresses[62] = address(0xB046B534aCa08C09A34377770214812dF81e97ba);
    walletAddresses[63] = address(0x200730fA35bA24BDed34f5BA3D0fbe7C2793CC7d);
    walletAddresses[64] = address(0xaF9c9D0A055d7ef11C98B96d3F1dC6Cbf115d3E9);
    walletAddresses[65] = address(0x82cD80cEe3E990eF869Ce1675DBDD29574881632);
    walletAddresses[66] = address(0xb626792a706e62263fe08b828C2f90aD4ef34601);
    walletAddresses[67] = address(0x3D460F28D48061B3bf1353B96c4Ba56011aD1FDc);
    walletAddresses[68] = address(0x3504a7abF0085Df70ebf5B5A6D73BFACe389aDC7);
    walletAddresses[69] = address(0x223Bce88Da17F5a33d6c2E553d4C2B6c4C46774E);
    walletAddresses[70] = address(0x773B1aCC268f8A0C6076752FcC042BaB87597718);
    walletAddresses[71] = address(0x355C966328BfCf5c354057fcd25F6ADA307FF670);
    walletAddresses[72] = address(0x0f0aBa0710AD81E74EfA24Ceb1e944f089c99138);
    walletAddresses[73] = address(0x2940ac02538F09C88a07d7e7C120780521367367);
    walletAddresses[74] = address(0x5539278fb689f3E0931cd6BD776d22A7fCf9d658);
    walletAddresses[75] = address(0xD20896ddc4B7f74d36d2444Fc86Cc00AB4Cc6975);
    walletAddresses[76] = address(0x2f4C868838D37837Ed3dDfFEee3332019d6f7E7d);
    walletAddresses[77] = address(0x7dd1500a7AE1c40d7287a09fcb13D8e3891B99F3);
    walletAddresses[78] = address(0x44CBf98851AcB26Aeb807C9dD5B8646fca6c7E7f);
    walletAddresses[79] = address(0xBd5cFdAA249Ac3A7e796B1bDe0e4771B59DE5b8F);
    walletAddresses[80] = address(0x2CE577E7d32230452e9B6f2198B91708E56BefaF);
    walletAddresses[81] = address(0x6f214a42d20016ddf15b6b89317445EFaaCDF1cA);
    walletAddresses[82] = address(0x075eE7f7D3e9D1cE6b3435c3B82990449ff424DE);
    walletAddresses[83] = address(0x027B40a6aa141ff6EE587985Ec391D77a2fFcE09);
    walletAddresses[84] = address(0xFC5f39AA7934E39a45564DA3Ec53D94fd7FF06b2);
    walletAddresses[85] = address(0xC8771De7f7D2811264937B6252B99DD12603C38A);
    walletAddresses[86] = address(0xb79840074e023e2fDB558E068FFCE119628b1242);
    walletAddresses[87] = address(0x917745978cBfB631DA987fcc74Cf291De1Eb472F);
    walletAddresses[88] = address(0x34222e9e32f35E36A542522Bf182F11b983145fF);
    walletAddresses[89] = address(0x511C3410FE6a60369610fCA7F081E72533049714);
    walletAddresses[90] = address(0xf35ec456867ae55040B8DBb6eE055bDAdAE6b5Ca);
    walletAddresses[91] = address(0x3bDa1748b7c7Df448ABAb42437CDcf9A78e3dD4C);
    walletAddresses[92] = address(0x6E1fDDd19848fdC02217609d1Ae731D8017bE56F);
    walletAddresses[93] = address(0xB27297a96AB6C383a6cfE224Cb32bD95545ED2aC);
    walletAddresses[94] = address(0xd2Ea1FB4977ba6e765D63c4d5Fb255f48b4630dD);
    walletAddresses[95] = address(0x944767B324D8e82DA56608BA62E857CeD15e7E18);
    walletAddresses[96] = address(0xb17a3CF0db9818e4E6C67da95AFcc643B5BC2352);
    walletAddresses[97] = address(0xdEDf9Ec3D22184e858Fd2Dd57D394867E6bBaDF5);
    walletAddresses[98] = address(0x76ee2b69843154E482f2E7bF1560F88e61b2A9BF);
    walletAddresses[99] = address(0x5806Ed580d58FfB5C8998E96BA8632DAc10d651A);
    walletAddresses[100] = address(0xdaFB06fbA44EB93f01438Ec85F3Fe83C16b17e69);
    walletAddresses[101] = address(0x8d50aD9DE85255401129d81a06e4049F32821e24);
    walletAddresses[102] = address(0xfb69ABfADd1A6f1929e988f41D2AAb0d09c48e63);
    walletAddresses[103] = address(0xa4a03a50feABA9243E8E41cb753598356121859a);
    walletAddresses[104] = address(0x25606e661B0A297c652ce8930F48a51CBC981D0E);
    walletAddresses[105] = address(0x871937A9f2E648Fe2409349c6Ae4c8C297fE1e2c);
    walletAddresses[106] = address(0xfFc67D03FfA1e54abD3c730e5a3FbC53d0F9Cb1b);
    walletAddresses[107] = address(0x72f9bEaaB502BD008B5459C00Cf1C114338BE0f9);
    walletAddresses[108] = address(0x25e5E6b9FaD64Fb5e2286DcCE60234ad02dCEDe8);
    walletAddresses[109] = address(0x9bA150561c80B8Dd5BbA76491E1aafaeca4f8fc7);
    walletAddresses[110] = address(0x0f3722728f9C44418e674788E9f9e85462de0d34);
    walletAddresses[111] = address(0x80C10BA7Bf8755963A4C6AFbFd80ef51BB78b3a7);
    walletAddresses[112] = address(0x691aB1859560408E5d460fa21E7Bce90529DFcDA);
    walletAddresses[113] = address(0xA6c16f497BFD1f83DD78E68a1D118b2719bAfd7f);
    walletAddresses[114] = address(0x0955f1D4311ed4880EAE25Dc1E00c0b6e1D2B700);
    walletAddresses[115] = address(0x78fb610dC0d3Ca90c07701a01645feE253541787);
    walletAddresses[116] = address(0x49A44B530939E1e5f810031Fb59fAf558B8A8804);
    walletAddresses[117] = address(0x8130E06eC246C9c527531E77580A5693Ac607e0a);
    walletAddresses[118] = address(0x2196AEF887278d7574FB92685Ad81b6B9BFEFD01);
    walletAddresses[119] = address(0x265c9e24EE81aB9FccE804305abae6260e8220b1);
    walletAddresses[120] = address(0x9B0DF7efbAF26d5D30Cb971701ce65c156a412B8);
    walletAddresses[121] = address(0x6b5229a0C800cF4e592CeADFc8a26CB29C5438c6);
    walletAddresses[122] = address(0xecC29f931502141F6590B8cC715eB5d8F6c46a4c);
    walletAddresses[123] = address(0x07279851D266b2F7FE2e70324FDC6435fB412413);
    walletAddresses[124] = address(0xA49A03F005caD5aaFdC71f7563A684427C6B6deF);
    walletAddresses[125] = address(0x863716642323daE111c6C46f35251AC88Df042Ca);
    walletAddresses[126] = address(0x08e391E8f3076dB0f6557e192F3f471dB9B1CD9B);
    walletAddresses[127] = address(0x540a0027509B1C9aA0a2c5C65491cC97083E16de);
    walletAddresses[128] = address(0x01aEC06b2c1ef3968A5AaE8b61A2f134D3bB0631);
    walletAddresses[129] = address(0xA2FF81b1Af38542EEe688B80f3371DF6295631F6);
    walletAddresses[130] = address(0x65a4b717D9950CC364aA37a89a78c2beF3559200);
    walletAddresses[131] = address(0x72AD3eceb1985c90eD7C48FF206A7B62ca5E9409);
    walletAddresses[132] = address(0x3E3a901dfC227c2964bD9C4F6892cbAf96C49cb4);
    walletAddresses[133] = address(0x074470B9A32F68De86faC393a10D5CeA01c54269);
    walletAddresses[134] = address(0x949C0066d5Cf2206a6a7C8727b0f0B7771e51c96);
    walletAddresses[135] = address(0x95dB4A4f11bC8ed8aA3610e9e41C91e01010CF1d);
    walletAddresses[136] = address(0x54A7A9769031CA0923De3AD054BC1813b65a9baf);
    walletAddresses[137] = address(0x5Aa019f56D83d53B80d9d3c15c6519E23F1C3e80);
    walletAddresses[138] = address(0xe2C785570f1580D84d3560F2800AeB7BBBf9ebd3);
    walletAddresses[139] = address(0xfa6c4421FE5015cFc24b38eC7c69Df0643B9ee0A);
    walletAddresses[140] = address(0x0222eafA2D9d85c405DF71Ddc037Ef856E7b08D4);
    walletAddresses[141] = address(0x4bBE965909c57A44991c3a0f367fE60073058b51);
    walletAddresses[142] = address(0x3cdD07924D746b5f32550031BA2C94b86013F86C);
    walletAddresses[143] = address(0x487226E99F143A33C5CFf4E18c04376Db8e67420);
    walletAddresses[144] = address(0x2D11771cB36FE73C1BaF76927d5e57Ea0F2514E6);
    walletAddresses[145] = address(0x18D165B68d7E52487a1Dfc464F46235d2E2a5443);
    walletAddresses[146] = address(0x2f55B2B9449B88c900b26C7329F6698a5FB93c84);
    walletAddresses[147] = address(0x15F408322A4f8f0cA4b079EaF3DCDDBc2E06a158);
    walletAddresses[148] = address(0x9eef8cd3EE9C2F74b74e76097d3C86392d525220);
    walletAddresses[149] = address(0xaBBe2A994d025d9F4DDD89FDcCEdB222DF3D6195);
    walletAddresses[150] = address(0xB94835172b8321bC98624815944248Fd9E9B6c2f);
    walletAddresses[151] = address(0xd83f76f728e0BbBbaEF7f0345cd8A1186AA94bC3);
    walletAddresses[152] = address(0x6b829179CE2d8Cf88a6DF95137e5599330E89E21);
    walletAddresses[153] = address(0xB3970Fb6a4b1Fea864612EeFC7c84131fadE72e0);
    walletAddresses[154] = address(0x8324694479F13c8171BDB5aD9eaAC532761Cb3fc);
    walletAddresses[155] = address(0xaF1987e23d6CFd183f967c510d4408857427E706);
    walletAddresses[156] = address(0x7cb9E1e495ca3293B96Df765d7CE5D30187D5CCd);
    walletAddresses[157] = address(0xe3AaF356F3933916CBC3550d9337dA591c69f8d6);
    walletAddresses[158] = address(0x88D452559a9f0B8f3481F652d16780De7b682E4c);
    walletAddresses[159] = address(0x6966fDede21643b743E1096aCc4BE81a922981b7);
    walletAddresses[160] = address(0x53ce5DfAFC79a39c0D9D4818a07200a38Fe86F96);
    walletAddresses[161] = address(0x95267193571fB01F531D8b41E714Fa194Ab9c41E);
    walletAddresses[162] = address(0xfFB33ec97B790d2E88783125C79450A4Fc8dbEF2);
    walletAddresses[163] = address(0xb1D2eC60Bc1FA5CCf0A718354E1C2c4D43cbA386);
    walletAddresses[164] = address(0x248F9AD777De90d51cD4cACb051330062D722931);
    walletAddresses[165] = address(0x5CaC52B88501C094BeA3bf2BE6E7bB27A3E97973);
    walletAddresses[166] = address(0xDa6E6B2946bF51CeeC50bEd6290097504E67778f);
    walletAddresses[167] = address(0xdA87234154A58f57a38E2D8AbA8404255B249A73);
    walletAddresses[168] = address(0x7ee8e8a632f42b25C7f938641105A1C304786945);
    walletAddresses[169] = address(0xe1F46b6082b2DB58Bf257C1d7F2C4D700F058d7b);
    walletAddresses[170] = address(0x5f5cD020309071AdFdAF064a8645E655c401A37F);
    walletAddresses[171] = address(0xA010971fcfeF68c34eD8d17d923895217F68Da1e);
    walletAddresses[172] = address(0x3c66Bb9C32954C189D473e80448B54FA3d092554);
    walletAddresses[173] = address(0x579B8e9a95305bEC8C116AD433C061Ef8BE06cA0);
    walletAddresses[174] = address(0xF6b61BfC76b7831eFF2c6Aae06759BBeC27b8ee2);
    walletAddresses[175] = address(0x423bcd110b1979A9E965EaF2EF82DA126eEA3B47);
    walletAddresses[176] = address(0xFC559a9619BF03a55ba7a93B6479B3E9c24295ab);
    walletAddresses[177] = address(0x16B586d9dc4120b607509E55927AcAbBE0F54099);
    walletAddresses[178] = address(0x550a98629C01e78d01d5F2579F68AdDae940698b);
    walletAddresses[179] = address(0xA6554A34e328A42d1357ADEd244cd04f2dE6ec88);
    walletAddresses[180] = address(0x2A982eB8a29F6d521AC10946a505408a954b90f3);
    walletAddresses[181] = address(0xe31314DAa763377D565C75bD339e91a09Cf89422);
    walletAddresses[182] = address(0x4afBC1aCD985185b702edBD0693206fA9acAb7E5);
    walletAddresses[183] = address(0xD07e20a52b71cE9c911385D04c79a2418Bf04502);
    walletAddresses[184] = address(0x74515ADDe515826443C0cd2bF919cbfDd1c20f01);
    walletAddresses[185] = address(0x00D63557A0476D4dE12956BC9E8EC328b7CaC197);
    walletAddresses[186] = address(0x14A130D2FCC0C2A453b0E7d3Be75D81696a600E3);
    walletAddresses[187] = address(0xB4E1D9F454BF848deE5C40aF3aa1e4D7E2a934f5);
    walletAddresses[188] = address(0xd4cD177E744d467736B08c842490c2621e025db7);
    walletAddresses[189] = address(0x373965D8a706C333A08301D44C87C7F84caAeC63);
    walletAddresses[190] = address(0xAa8DCef16b82c04D65fBfa29403f3000B9E398Ab);
    walletAddresses[191] = address(0xD046D27C2aC272Ec695913A9EB5293BBBDA98f17);
    walletAddresses[192] = address(0xd8dC36bD58a40f8ed5CB0Eb3E8042EE28AF6DAaa);
    walletAddresses[193] = address(0x4B16bE6658dD60216147aD32362bB7949Aa0DbB0);
    walletAddresses[194] = address(0xC9590d25eA0B3f6863D04689C0C247Dc41F84D3b);
    walletAddresses[195] = address(0x4b99251BA92B278D1C2b4b07d82904Bea9AF8b9d);
    walletAddresses[196] = address(0x8aaC10A432f458C05ceA8fD19B71853E4de0aF7B);
    walletAddresses[197] = address(0xC0eA3aFEb9A83EF8f83A5Df7C563a3b7c4A5fAe4);
    walletAddresses[198] = address(0xC4d1e22E995870ECA6BE63e34294337A351C9D76);
    walletAddresses[199] = address(0x7B550374d1213300E728625B5A86175Ca6E8d47f);
    walletAddresses[200] = address(0x9a0F62b9A86187A03f4459D3130e9792eEE8aEB9);
    walletAddresses[201] = address(0xa8bCBccb087AC2C185171532983Ff0f493CB56ee);
    walletAddresses[202] = address(0x2955671AF63F272f0044D096D002808D26AaECD2);
    walletAddresses[203] = address(0x003E640E2d54C0142ee8B83fAf7E529Db98df592);
    walletAddresses[204] = address(0xDb5dceD2096a2D5fF4C89911220078F88899Cc00);
    walletAddresses[205] = address(0x05CB44F8ac18cb2deD4cabd906FeC6876E941D27);
    walletAddresses[206] = address(0x5e73dB576902084f7B7Bc0c099eF6eedeFa20bf6);
    walletAddresses[207] = address(0x1E61A8cD14dCD6e769244e23aC1416cDc38A52d3);
    walletAddresses[208] = address(0xe648111d3EEc4C61B9c05994aA97587e7c841860);
    walletAddresses[209] = address(0x5F95f0350e55db5e9fE6f33A85CFF89a49Ec5ad7);
    walletAddresses[210] = address(0x2d3735E7619c6684d33e1729094B83B4946f4e0c);
    walletAddresses[211] = address(0x0E43C7A950406273b05066108eDC15Cea53E6289);
    walletAddresses[212] = address(0x8d71924BE0b17a8d37eA737B57430a899450F860);
    walletAddresses[213] = address(0x073d2bbA4D7ab11231b67Ca89F447c92fe447CF6);
    walletAddresses[214] = address(0xb6A11ae07e0201D4f44073Fa568Ab70677af17B8);
    walletAddresses[215] = address(0x35ac812B731E8311dd0B30DE73B0236a20C8bDe4);
    walletAddresses[216] = address(0x374801c2999C8c41202e3f9245290570DbbC7D76);
    walletAddresses[217] = address(0xfDfd5885f2A8031CaC6BB7112AbAb48E68EF3A8b);
    walletAddresses[218] = address(0x007d6c079Da209f7a956C8B1b69E4178c6DBaCC1);
    walletAddresses[219] = address(0x2BE89e8fC2D26431FeeeAA8DBE7a378E73a7a334);
    walletAddresses[220] = address(0xD73896109136f43064Ddb655689636d303930EbB);
    walletAddresses[221] = address(0x299885eBCA63B4D3b50Ed3A0D18907267e2bf851);
    walletAddresses[222] = address(0xbb46E65BAB7719C3819b1f7524B3f3878D8eC2A9);
    walletAddresses[223] = address(0x833A54cA612f9f4dFaC75600d133af399329dA81);
    walletAddresses[224] = address(0xB23326ddF67F6CdA92AB78132eE50F04311Dc78b);
    walletAddresses[225] = address(0xD2fab17Fd83e9dF3a36b1F694893A3f3F575EDd6);
    walletAddresses[226] = address(0xE1128a10F9a093209080Dd6476aD3e67b6a7c492);
    walletAddresses[227] = address(0x15dDa6b8b408ac2d91e4B9316D0dF2cd2E60920B);
    walletAddresses[228] = address(0x6EBcd1bFfb2d6be2Efc3C33f09250A95745B7bb1);
    walletAddresses[229] = address(0x3E42D29bAC0A7FB3281c6d8C007e06e173cAB787);
    walletAddresses[230] = address(0xD4BDd6F8CcCD88fd8c4BBF6B63e000FE483bA8DA);
    walletAddresses[231] = address(0x71b94CaCF08deb68525113613622052F32b7059E);
    walletAddresses[232] = address(0x8536121F1e44AD665930043947AA73Ff917cb31d);
    walletAddresses[233] = address(0xDd614438eEA44835B9eF800247ef53fE090f6519);
    walletAddresses[234] = address(0x6e211A52A890E0f247C9cEfeEf7f256C58001c45);
    walletAddresses[235] = address(0xc4a5b05a4b0EACd61C4B3C9b9F00D3724EeE8821);
    walletAddresses[236] = address(0x537245E8AA6d23736Df2eb1d62D4F91dA4d02D49);
    walletAddresses[237] = address(0xc1B95d44dC58AeD5D49ef2A32d1C61958329c3d1);
    walletAddresses[238] = address(0x14739869Bd8Bdb9318B59d7F16Af2d4B0BceaA61);
    walletAddresses[239] = address(0xD11Ae7b054D9b0c533a06D4518F67c6945a70D24);
    walletAddresses[240] = address(0x021B47851C123c955ABC6dD73bE88F0BcaFda5a7);
    walletAddresses[241] = address(0x91bA15ACB800EfE7a0aa344C0Fdd535929969e3c);
    walletAddresses[242] = address(0x962c637Da54577B64Ed50bF091643c3C4d70202D);
    walletAddresses[243] = address(0x657C79bEC8Dcd761cD5Aa8C0419EA59E1515Ec1b);
    walletAddresses[244] = address(0x6a4FD43a0D67f79C311E01c89b20c35478C254B7);
    walletAddresses[245] = address(0x4575b72e144fA9Ee3Fc28D9dbFE5a7ec099e6e5a);
    walletAddresses[246] = address(0x76F34d1a4535241eC054b49d969bdB37F444eb38);
    walletAddresses[247] = address(0x33c0afd48266cb529EaA1b61f4D84Ba7017B9743);
    walletAddresses[248] = address(0xa9bD541933251cbeb6BD522290745B5b49137295);
    walletAddresses[249] = address(0x05082795F56B242BdF4F642d0C92f99F7A08C72A);
    walletAddresses[250] = address(0xadbC9C61707f00E4862dC9AaDC814C4902D03A93);
    walletAddresses[251] = address(0x34E6f42cF41038250af29Ec83E0234bd2aca6F64);
    walletAddresses[252] = address(0xB1645DA9e8AD34EF1A503289992f1D08127e941C);
    walletAddresses[253] = address(0x06cCe910faDBAC79df49F8Ae278b02A319fC19ff);
    walletAddresses[254] = address(0x5Df8a4c5f8724b0b25EC604B816a37383be39150);
    walletAddresses[255] = address(0x2f8Be4944Fb45C260eF66040e370d0216930Eac9);
    walletAddresses[256] = address(0x9d567bA6cd1368DD6D200bA5a30e0A18BbE6DB08);
    walletAddresses[257] = address(0x1994Fc3419e0C09bEB1612013143C2A75C59E35C);
    walletAddresses[258] = address(0x9762152Be788CEA03DeF996FA3B3378e31a56E9b);
    walletAddresses[259] = address(0xA991bB21581Df80a131F22138cAD607035D722d6);
    walletAddresses[260] = address(0x05221d7179e8CC359FB500F3e77607af4AC0E205);
    walletAddresses[261] = address(0x5037ac29A633eeC00f327402F264512AD45ddf56);
    walletAddresses[262] = address(0x9b714fd21B281B2684392626a4932Ec74972e64C);
    walletAddresses[263] = address(0x1FEc3eF8956aBf282FB92A00bBFb107784A13F36);
    walletAddresses[264] = address(0xe90e71f662722fC4cB14c53C628217EEefD77a0b);
    walletAddresses[265] = address(0xDf9e2E41758a91eC18E4d8f05551BeCCE340859a);
    walletAddresses[266] = address(0x030A0Bcef926B4F6929770847074fdB5bdeb86f8);
    walletAddresses[267] = address(0xe011C719335ceF32d1C4A1898bfb18a3B49A25D8);
    walletAddresses[268] = address(0x00DC3537D2485400e1557900cd75556B3025Fda4);
    walletAddresses[269] = address(0x116c00dBdBAe8ce512CB3cd129Ef7ba2F63963CD);
    walletAddresses[270] = address(0xb6Eb414950d92350CF39989bAC3Fffe9aF604774);
    walletAddresses[271] = address(0xD79e6C205F09cE04DC740777372405FFfDef2f93);
    walletAddresses[272] = address(0x5b1a07edafE63d527fD5aE62ca0E3087e89528D8);
    walletAddresses[273] = address(0x246C976aDC86cf23c78039e14769D7F28d9CB670);
    walletAddresses[274] = address(0x03418262105fCfDE837c1C5DA9beC78dF0Dd5122);
    walletAddresses[275] = address(0x8b8cdD509E3C18Ae277cb0716e70D067BE28799a);
    walletAddresses[276] = address(0xD7bd91A086776AD813B3b7F0D0BaFE7887677d79);
    walletAddresses[277] = address(0x49F65fe360a0aEE3fF2c5Fe7eA4F154D48095853);
    walletAddresses[278] = address(0xE3B5993160feD0bcd133ae370231d9bf7DEfEC3b);
    walletAddresses[279] = address(0x9CB96420efB2B4149E5cf0a5715f0f8a79c3C35B);
    walletAddresses[280] = address(0x44e3c7eA211390c9a2103a54920fBbcaCFb06310);
    walletAddresses[281] = address(0xDe96e75c7160d70a447a72AFdb75DDfA1455c808);
    walletAddresses[282] = address(0x8BbB52bCAe88Edf3945AD228D15143bA5cC5b348);
    walletAddresses[283] = address(0x1bC5Ac29A07F8528887135924Cc4a9E21698725a);
    walletAddresses[284] = address(0x0dB2Cd0b5Bac9B66FA59d387D4eA89EFB8E8a0f0);
    walletAddresses[285] = address(0x83d820d2A7c35092B9518ACe0B8310ebbFf7A384);
    walletAddresses[286] = address(0x2f0970F66b1Ca886f7A469F3d2B403325BA8Ff32);
    walletAddresses[287] = address(0x832b89EAC478F0Dc2F6598BA32711cE8bC989e65);
    walletAddresses[288] = address(0xA79C38814338ABB278e10cf050E97983a5a426df);
    walletAddresses[289] = address(0xc8bE65461C6Aca350A7C673451470eB5EFc54dDd);
    walletAddresses[290] = address(0xA503284eB695461447F046136731f3Ae3740F3bD);
    walletAddresses[291] = address(0x4Cb45380ae0D03E31494985f5F4f03187C3af4c0);
    walletAddresses[292] = address(0x4A410b2d4ccC2aE3691A135C7B39967410BDc4E4);
    walletAddresses[293] = address(0xeB309eFdEb410f67C976D8d4B473a89dAfB5e25c);
    walletAddresses[294] = address(0x67bAe3D008d8870F3548A8203884EbfcBE5753ff);
    walletAddresses[295] = address(0x3BB6Af6BD74F4c4DaBE144Dbe30C05Ec74bA549C);
    walletAddresses[296] = address(0xFB6eA090DE39bd7048962acce94c6d3b14873F15);
    walletAddresses[297] = address(0xECbF8D98338cAd1DaA7AC918A5713593Ea373c29);
    walletAddresses[298] = address(0x08761cd9c2B561227A1E0C39992440907de1D21a);
    walletAddresses[299] = address(0xb22eBa27F0A9bd3C4f7e936D0BbEb0B89E127087);
    walletAddresses[300] = address(0x81ACC319a1A50C0FaeBd6882643A0CC8b6Da5A18);
    walletAddresses[301] = address(0x936eCE6E6FeEFfFD1185F14cccA3c30aaaCD3F6a);
    walletAddresses[302] = address(0xBCd90180d8B07D9D7Bf933881e62Ffad977d3B24);
    walletAddresses[303] = address(0x26975533aB856bFc7D07F6232f6DE863A8dBCcb9);
    walletAddresses[304] = address(0xCd83c5970f8b92142EF6DB1CCADAC68f01DF1c44);
    walletAddresses[305] = address(0x96Da385E15E656b88a42905c7600B316BaccA3CE);
    walletAddresses[306] = address(0xb600309084C44826f9C103C20a5FF991944A5BD5);
    walletAddresses[307] = address(0x707e0c6E37bB0E9655511d0994eeF9BdAE8C906c);
    walletAddresses[308] = address(0xffA5EE39F01D95c010C2bf229368FCee13a71888);
    walletAddresses[309] = address(0x68283c626110c451c529cB65Ebe8225E524A33fB);
    walletAddresses[310] = address(0xC0a3701C4A8A60fD6E809567A96e3c24c2e0cD28);
    walletAddresses[311] = address(0x4FA9e659Df8333E5c4F7901C2a5Efb867c2E9053);
    walletAddresses[312] = address(0x1C80650505615863a45200B86F6bB4930DA82651);
    walletAddresses[313] = address(0xc6EFdB57b3E5E3958e40362FAc8dff6d7895093C);
    walletAddresses[314] = address(0x17A5267f009e517D12B07bfC19aea5d92B952B89);
    walletAddresses[315] = address(0xB1987db9fbAc8e45D8D8ACf2236c1e5Be3571b9c);
    walletAddresses[316] = address(0x3eAf0C243c2C37cdD054Bb14345fd8010A377C90);
    walletAddresses[317] = address(0x27e99BA78D4c66D43bC1cdBA85F46324D78D1820);
    walletAddresses[318] = address(0xAF2529985472392eA4C1c5f0443E0f7078071006);
    walletAddresses[319] = address(0x7EFcD07DC6012478BF8218e9c81bCAb71C0b0477);
    walletAddresses[320] = address(0x026304f67FD6b8D3ff0453CF36e3Cf38225FD57e);
    walletAddresses[321] = address(0x24841854081AA1ECA40FcE1794de822C3A4d64C7);
    walletAddresses[322] = address(0xeFEEec518F6C7cAcF0386D92ca8f739c48418E81);
    walletAddresses[323] = address(0x77f4039cC562fD69364301939c214a7b388ae183);
    walletAddresses[324] = address(0x50a34Bf23687F13e8aD435b5244Fe70D27e031D3);
    walletAddresses[325] = address(0x9F7384Eb8705DAb8bd769Df6499644854DcB32bA);
    walletAddresses[326] = address(0x2881e46723BD5a890700233F114D37773eA4202E);
    walletAddresses[327] = address(0xf1525656035A3551cb5674e6AA8c890799E9fEC1);
    walletAddresses[328] = address(0x9e5b5E43892658e8f9193d9F4A07f2165026E714);
    walletAddresses[329] = address(0xe51ad9fB52527A9bC4C6fdBE22E84c9c3208c595);
    walletAddresses[330] = address(0x0DD0bD8574a4BA945427C4eb72Ce3371b776c30B);
    walletAddresses[331] = address(0x046E81A02FDe0bA0644417E4FC1fD061189D2a96);
    walletAddresses[332] = address(0xc61D40d3EDaAb562E369803D5deEedD6a51132C2);
    walletAddresses[333] = address(0x035291661D47732fA22f03B7ede69d3bcC0E2884);
    walletAddresses[334] = address(0x75dD2C1808F9302d14EBBF4bC2b64B3B64288866);
    walletAddresses[335] = address(0x7FE36EF874e6C1dD080A9DA48b1a22234A7F8454);
    walletAddresses[336] = address(0x7963780Bd8B5261C8B91fc381b4D745ad2FAA216);
    walletAddresses[337] = address(0x8F884379C832058B88cDca91357c74C6eD4F366B);
    walletAddresses[338] = address(0xDf721779D897E9345FaadED8C26550f836Bf5233);
    walletAddresses[339] = address(0x921D90131fE8A8799dC8ad5B76bb72b5f7a2786f);
    walletAddresses[340] = address(0xfd059b2B44B1B493B3AC5C37C4E852c13ac90191);
    walletAddresses[341] = address(0x2AE27f5D0b8E48F75174F28d51188905EC1b666b);
    walletAddresses[342] = address(0x426A59A6fDCDe44E5ad28791D21e3E2AFf447498);
    walletAddresses[343] = address(0xe5e81625cAa2257a0A67E79628F8C61703f5071B);
    walletAddresses[344] = address(0xA0f614D8a255928eD45f99Bd9D53FBc29D4629d3);
    walletAddresses[345] = address(0xC96Ba7D26D7703eaF3dDF6d8fF59a7F284BF010b);
    walletAddresses[346] = address(0x33Db50C673195940D7d53eE27A446f12f9cFa796);
    walletAddresses[347] = address(0xb148c70f16EC61896851494127CEdAE7cc23E567);
    walletAddresses[348] = address(0x39fc72C60257eE99D4E72A0e48cC683Ee43Ec115);
    walletAddresses[349] = address(0xb32D72C1Afd5F8dBc70A243F648838bA296cd886);
    walletAddresses[350] = address(0xc3fa910305ff8C39a3231da62B326a15f7aC9121);
    walletAddresses[351] = address(0xa480C16344b29C54b21941cE55b6443a28CAF40A);
    walletAddresses[352] = address(0xe935f918b76Fa047128E23c42369e5818A03762A);
    walletAddresses[353] = address(0x9871D929C13e4CcAA227F4241F1Fe96c8a1D6740);
    walletAddresses[354] = address(0x2ee496CcE31d59af5A3c4Df8585E30f693e1ac9F);
    walletAddresses[355] = address(0x2a88aE96Ca65e4c393c3ca6b063F4f60943e28Cf);
    walletAddresses[356] = address(0x17E6E05EA6B6054Db3BFC6E25FA4F8CDd4F31675);
    walletAddresses[357] = address(0x877C5E22AaF65877d4E4CCB89B2E08Ff0Ecb9bD9);
    walletAddresses[358] = address(0x80f68594Abdde7cf2D7218CD41b7a0183101b076);
    walletAddresses[359] = address(0x2C43aF33B7B20b6869Cf907d248F50421f538CD5);
    walletAddresses[360] = address(0x749Bd42Ca0E20307fFe65626BEDa99DB48be5E2C);
    walletAddresses[361] = address(0xb889cE7B7fAA6faAA09704BcD232493044505727);
    walletAddresses[362] = address(0xe300a1d9f8ED42D80D5CcBB95dbC3ecF090CaA66);
    walletAddresses[363] = address(0x8bEC971556f078243E30c292B9B0CE701F75D62c);
    walletAddresses[364] = address(0x92336278EC72395dce21E2C34453B08eCD208624);
    walletAddresses[365] = address(0xC3dcd0595cB0a9167653688d854d40607c5d8652);
    walletAddresses[366] = address(0x076E16Ca5564d32A63F4FA62e83CE295197d663F);
    walletAddresses[367] = address(0xF08789bB2E7BB5f9FA082EC5Fc0986E9240f41B1);
    walletAddresses[368] = address(0xc4c1e91ec760E1Bf75B138B718CDd95b709d3557);
    walletAddresses[369] = address(0x504e42B95F004fF96519e4c46371bEC7e5114A25);
    walletAddresses[370] = address(0x1A8d6D5aBd8948B647C51bb7B071B718fD90D6ff);
    walletAddresses[371] = address(0x2a402a12723457ce8243A70B63F745c462Bd11f9);
    walletAddresses[372] = address(0xed74681d22FFd57Fd365eB25745FD2f2930Fda50);
    walletAddresses[373] = address(0x87058292F212cc4eB6560debae7283D3CF0a5b3F);
    walletAddresses[374] = address(0xbc57c650e52dfe86804dA04681089ec276104383);
    walletAddresses[375] = address(0x92257E76A26aF7DDBf94cbed54067994DB907Fa6);
    walletAddresses[376] = address(0x6E36A7328BAE4a285A7B0DCefe0b5687c2Ee74fc);
    walletAddresses[377] = address(0x8618Ca2d031CDb97593Bbb71eFa736cEE32Fd07b);
    walletAddresses[378] = address(0x8152553D979d960C4671dBa0B4Da730953aC9044);
    walletAddresses[379] = address(0x4162f6a7893ACf74adC0dc0728aCbEf34b6E4B26);
    walletAddresses[380] = address(0x43F02E7255F8E85DEa8b6167090eA77AB57446c7);
    walletAddresses[381] = address(0xcD0D967449430CaaaBDa422aF22F64254c3F1168);
    walletAddresses[382] = address(0x47b9857fd53E0Bda751AbaF0568313e1D946a5cf);
    walletAddresses[383] = address(0x2F061aA574882C84649230b475a44D35795cC018);
    walletAddresses[384] = address(0x892FfEb3e569f0247524bD901eb3d935E66463a6);
    walletAddresses[385] = address(0x327140FF891b74bd65E4A0E4f601279ac0Bd6A77);
    walletAddresses[386] = address(0x0a6bC3389f4eCA70A1c97e357c689279f12c9460);
    walletAddresses[387] = address(0xf22ACEF7a82F850a8bE83f920FA3566238684CF1);
    walletAddresses[388] = address(0xeC44aA9632190B9e8F68E66E043e2A7A5697e9A7);
    walletAddresses[389] = address(0x808877E13A1e56Fe38f845eDC88B327C9acEA888);
    walletAddresses[390] = address(0x98567f99F4Fa092ABC4Ee4893D6F4d76C8d52653);
    walletAddresses[391] = address(0xe5F8Caa6fDc43e6D1100151321BFE6780603A157);
    walletAddresses[392] = address(0x03e151cc8D7e41852f8B0D1F8A7c32D49027741A);
    walletAddresses[393] = address(0x0571C41554A0C21A81267cdBa0FBC33A28F36b82);
    walletAddresses[394] = address(0xA1bB99010a8422960AE014A37dbaDC238dE0cd25);
    walletAddresses[395] = address(0x49576aCe069A019A5eBAb5cdC097AD6F083D74E5);
    walletAddresses[396] = address(0x48f3a307Da448129fCB7C43E52678953e13C683B);
    walletAddresses[397] = address(0xfD8C3270bb87CbE622D0Bca73EcAA38d4Bf543a8);
    walletAddresses[398] = address(0x1E3e6317B9D88a146173a84C828C110C03D756b6);
    walletAddresses[399] = address(0x3c475ec22d29FCd6a5338593C0173Be9bA0160f9);

    uint256[] memory playerIds = new uint256[](walletAddresses.length);
    uint32[] memory coordinatesX = new uint32[](walletAddresses.length);
    uint32[] memory coordinatesY = new uint32[](walletAddresses.length);
    for (uint i = 0; i < walletAddresses.length; i++) {
      uint256 playerId = AccountPlayer.get(walletAddresses[i]);
      playerIds[i] = playerId;
      PlayerData memory playerData = Player.get(playerId);

      coordinatesX[i] = playerData.claimedIslandX;
      coordinatesY[i] = playerData.claimedIslandY;
      if (coordinatesX[i] == uint32(0) || coordinatesY[i] == uint32(0)) {
        console.log("Address=%s,X=%d,Y=%d", walletAddresses[i], coordinatesX[i], coordinatesY[i]);
        vm.stopBroadcast();
        return;
      }
    }

    ItemIdQuantityPair[] memory toAirDropResoures = createIslandResources();
    uint32[] memory resourcesItemIds = new uint32[](toAirDropResoures.length);
    uint32[] memory resourcesQuantities = new uint32[](toAirDropResoures.length);
    for (uint i = 0; i < toAirDropResoures.length; i++) {
      resourcesItemIds[i] = toAirDropResoures[i].itemId;
      resourcesQuantities[i] = toAirDropResoures[i].quantity;
    }

    SystemCallData[] memory calls = new SystemCallData[](coordinatesX.length);
    for (uint i = 0; i < coordinatesX.length; i++) {
      calls[i].systemId = systemId;
      calls[i].callData = abi.encodeWithSignature(
        "mapAirdrop(uint32,uint32,uint32[],uint32[])",
        coordinatesX[i],
        coordinatesY[i],
        resourcesItemIds,
        resourcesQuantities
      );
    }
    bytes[] memory returnData = IWorld(worldAddress).batchCall(calls);
    for (uint i = 0; i < returnData.length; i++) {
      console.log("The return value is:");
      console.logBytes(returnData[i]);
    }
    //world.app__islandClaimWhitelistUpdate(accountAddress, allowed);
    vm.stopBroadcast();
  }

  function createIslandResources() internal view returns (ItemIdQuantityPair[] memory) {
    ItemIdQuantityPair[] memory resources = new ItemIdQuantityPair[](3);
    resources[0] = ItemIdQuantityPair(COTTON_SEEDS_ITEM_ID, resouceCottonSeedsQuantity); // CottonSeeds
    resources[1] = ItemIdQuantityPair(RESOURCE_TYPE_WOODCUTTING_ITEM_ID, resourceWoodCuttingQuantity); // ResourceTypeWoodcutting
    resources[2] = ItemIdQuantityPair(RESOURCE_TYPE_MINING_ITEM_ID, resourceMinningQuantity); // ResourceTypeMining
    //resources[3] = ItemIdQuantityPair(POTATO_SEEDS_ITEM_ID, resoucePotatoSeedsQuantity); // PotatoSeeds
    return resources;
  }

  function logIslandResources(ItemIdQuantityPair[] memory resources) internal view {
    console.log("With the following resources:");
    for (uint i = 0; i < resources.length; i++) {
      console.log("    ItemId: %d, Quantity: %d", resources[i].itemId, resources[i].quantity);
    }
  }
}
