# 项目合约代码结构与 DDDML 模型驱动开发说明

## 对本文读者的要求

* 对 MUD 框架，以及使用 MUD 框架开发的 Dapp 的结构有基本的了解。
* 对 DDDML 有大致的概念。

这里有一篇关于使用 DDDML 以及相关工具进行 MUD 应用开发的入门参考文章：https://hackmd.io/GjSU_oWvTlCtMBtIA28SiA


## 项目合约代码的生成过程


```ascii
                   DDDML Models (*.yaml)
                          │
                          │ dddappp tool (MUD version)
                          ▼
     ┌─────────────────────────────────────────┐
     │                                         │
     ▼                                         ▼
MUD Data Model                          MUD Systems
(mud.config.ts)                    (*System.sol / *Logic.sol)
     │                                         │
     │ mud tablegen                            │ mud worldgen
     ▼                                         ▼
Tables (DAL)                          Interfaces
(codegen/tables/*.sol)               (codegen/world/*.sol)
     │                                         │
     └─────────────────┐     ┌─────────────────┘
                       │     │
                       ▼     ▼
                   Final Contract
                      Code
```

这个图展示了从 DDDML 模型到最终合约代码的转换过程：

1. DDDML 模型（在 `dddml` 目录下的 `*.yaml` 文件）是最高层的抽象，它描述了领域模型
2. dddappp 工具（MUD 版本）将 DDDML 模型转换为：
   - MUD 数据模型（在 `mud.config.ts` 文件中）
   - MUD Systems（Solidity 合约）以及模型中定义的“方法”所对应的“业务逻辑”脚手架代码
3. MUD 工具链进一步处理：
   - tablegen 从 MUD 数据模型生成 DAL 代码
   - worldgen 从 MUD Systems 提取接口定义
4. 最终所有这些代码组合成完整的合约代码（需要开发者填充“业务逻辑”的实现代码）


## 合约项目的结构

可以使用 tree 命令查看合约项目的结构：

```
cd packages/contracts
tree .
```

我们在输出的内容中加上了注释，以解释每个目录和文件的作用：

```txt
.
├── ...
├── script // 部署以及其他运维脚本
│   ├── ...
│   ├── PostDeploy.s.sol
│   └── ...
├── src
│   ├── codegen // 这个目录中的所有文件都是 MUD 的工具生成的
│   │   ├── index.sol
│   │   ├── tables // MUD 工具生成的 DAL（数据访问层）代码
│   │   │   ├── EnergyDrop.sol
│   │   │   ├── ...
│   │   │   └── XpTableLevelCount.sol
│   │   └── world // 这个目录中的所有文件都是 MUD 的工具生成的接口
│   │       ├── IAggregatorServiceSystem.sol
│   │       ├── ...
│   │       └── IWorld.sol
│   ├── systems // 这个目录下只有后缀名为 `Logic.sol` 以及 `ServiceSystem.sol` 的文件是包含了手动编码的
│   │   ├── EnergyDropRequestLogic.sol
│   │   ├── ExperienceTableAddLevelLogic.sol
│   │   ├── IslandClaimWhitelistAddLogic.sol
│   │   ├── ...
│   │   ├── ItemProductionCreateLogic.sol
│   │   ├── ItemUpdateLogic.sol
│   │   ├── MapAddIslandLogic.sol
│   │   ├── ...
│   │   ├── AggregatorServiceSystem.sol
│   │   ├── ShipBattleServiceSystem.sol
│   │   ├── ...
│   ├── tokens // ENERGY ERC-20 合约，项目使用的 ENERGY 代币的合约地址是可以配置的
│   │   └── Energy.sol
│   └── utils // 工具函数
│       ├── DirectRouteUtil.sol
│       ├── ExperienceTableUtil.sol
│       ├── FightToDeath.sol
│       ├── ItemIds.sol
│       ├── LootUtil.sol
│       ├── MapUtil.sol
│       ├── PlayerInventoryUpdateUtil.sol
│       ├── PlayerUtil.sol
│       ├── RosterDataInstance.sol
│       ├── RosterSailUtil.sol
│       ├── RosterUtil.sol
│       ├── RouteUtil.sol
│       ├── ShipBattleUtil.sol
│       ├── ShipIdUtil.sol
│       ├── ShipInventoryUpdateUtil.sol
│       ├── ShipUtil.sol
│       ├── SkillProcessUtil.sol
│       ├── SortedVectorUtil.sol
│       ├── SpeedUtil.sol
│       └── TsRandomUtil.sol
├── test // 单元测试
│   ├── ShipIdUtilTest.t.sol
│   └── ...

```


## DDDML 模型到合约代码的映射

### 典型的实体模型以及生成的代码

### 其他对象模型以及生成的代码

### 生成的代码与手写代码的关系

### 模型中的关键声明以及对生成的代码的影响


[待补充具体内容]

