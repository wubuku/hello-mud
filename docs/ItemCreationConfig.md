# Item Creation & Item Production Config

```solidity
function app__itemCreationUpdate(

  uint8 skillType,

  uint32 itemId,

  uint16 requirementsLevel,

  uint32 baseQuantity,

  uint32 baseExperience,

  uint64 baseCreationTime,

  uint64 energyCost,

  uint16 successRate,

  uint32 resourceCost

 ) external;
```


```solidity
function app__itemProductionUpdate(

  uint8 skillType,

  uint32 itemId,

  uint16 requirementsLevel,

  uint32 baseQuantity,

  uint32 baseExperience,

  uint64 baseCreationTime,

  uint64 energyCost,

  uint16 successRate,

  uint32[] memory materialItemIds,

  uint32[] memory materialItemQuantities

 ) external;
```






```solidity
 uint8 constant MINING = 3;

 uint8 constant WOODCUTTING = 1;

 uint8 constant FARMING = 0;

 uint8 constant CRAFTING = 6;
```



| itemCreationIdSkillType | itemCreationIdItemId | requirementsLevel | baseQuantity | baseExperience | baseCreationTime | energyCost          | successRate | resourceCost |
| ----------------------- | -------------------- | ----------------- | ------------ | -------------- | ---------------- | ------------------- | ----------- | ------------ |
| 3                       | 301                  | 1                 | 1            | 0              | 3                | 1000000000000000000 | 100         | 1            |
| 1                       | 200                  | 1                 | 1            | 0              | 3                | 1000000000000000000 | 100         | 1            |



| itemProductionIdSkillType | itemProductionIdItemId | requirementsLevel | baseQuantity | baseExperience | baseCreationTime | energyCost          | successRate | materialItemIds | materialItemQuantities |
| ------------------------- | ---------------------- | ----------------- | ------------ | -------------- | ---------------- | ------------------- | ----------- | --------------- | ---------------------- |
| 0                         | 102                    | 1                 | 1            | 0              | 15               | 5000000000000000000 | 100         | 2               | 1                      |
| 6                         | 1000000001             | 1                 | 1            | 0              | 15               | 5000000000000000000 | 100         | 102, 200, 301   | 3, 3, 3                |


```shell
cast send --private-key __PRIVATE_KEY__ \
__WORLD_ADDRESS__ \
'app__itemProductionUpdate(uint8,uint32,uint16,uint32,uint32,uint64,uint64,uint16,uint32[],uint32[])' \
'0' '102' '1' '1' '0' '3' '1000000000000000000' '100' '[2]' '[1]'
```

