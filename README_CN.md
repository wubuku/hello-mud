# 以低代码方式开发 EVM 去中心化应用

[English](./README.md) | 中文版

这是一个以低代码方式开发使用 MUD 框架的去中心化应用的示例。

低代码的核心是“模型驱动”。
我们会展示如何使用一门称为 DDDML 的 DSL（领域特定语言）来描述应用的领域模型，
然后将领域模型转换为 MUD 的配置（模型）文件以及 Solidity 合约代码，从而加速应用开发的整个过程。

> 我们正在将全链游戏 [Infinite Seas](http://infiniteseas.io) 移植到 EVM。
> 
> 在当前代码库的 `./dddml` 目录下，你可以看到我们为 Infinite Seas 所设计的大部分 DDDML 模型文件。
> 我们将它们包含进来作为示例的一部分，以便你可以看到 DDDML 的实际应用。
> 
> 我们使用几乎完全相同的模型文件来驱动 Infinite Seas 的 Sui 版本以及 Aptos 版本的开发。
> 熟悉 Move 生态的人应该知道，虽然 Sui 和 Aptos 都使用了 Move 语言，但是它们在诸多细节，特别是状态存储机制上存在非常大的差异。
> 
> 在当前的 Web3 开发领域，唯有 DDDML 这样高度抽象、凝练的 DSL 可以让我们如此从容地完成一个复杂去中心化应用的移植工作。


## 动机

有人可能会问：既然是基于 MUD 之上来做事情，为什么不直接使用 MUD 框架？

简单说：为了更高的开发效率。

虽然 MUD 是一个很好的开发框架，但它也有一些局限性。

最显而易见的一点是，它与 EVM/Solidity 生态紧密耦合；我们不能用它为其他生态开发去中心化应用。

还有，虽然 MUD 声称自己是一个通用的应用开发框架，而非仅适用于链上游戏的开发，
但实际上，大多数开发者还是将其视为全链游戏引擎。
而对于链上游戏开发来说，MUD 没有引入任何链下的混合解决方案来提高游戏的 tickrate。
可能 MUD 的初衷是想尽可能地保持“链上”，但是很明显，这是一种限制而非优势。

我们相信，采用模型驱动的低代码开发方法不仅可以提供更高的开发效率，还可以补全 MUD 的这些不足之处。

你可能已经注意到，MUD 中也有“数据模型”的概念，但是它和我们的低代码方法所采用的领域模型处于不同的抽象层次。

在 MUD 的配置文件中定义的模型，是抽象层次较低的“物理数据模型”。它基本上可以看作是程序的实现代码的一部分。

我们都知道，编程实现并不是软件开发的全部。特别是对于复杂的软件开发而言，它甚至不是开发过程中最耗时的部分。
要开发高质量的软件，我们需要在分析阶段和设计阶段投入足够的努力。
我们还要保证实现的代码能够反映分析和顶层设计的成果，
唯有如此，代码才具备良好的可维护性。

我们的低代码开发方法采用的是 DDD（领域驱动设计）风格的领域模型。
DDD 领域模型是面向对象分析（OOA）模型和面向对象设计（OOD）模型的有机结合。

我们设计了一门极具表达力的 DSL 来描述这种领域模型。
我们甚至可以在软件开发的需求分析阶段就使用它来构建概念领域模型；
在设计和编码阶段，我们是在同一个模型的基础上添砖加瓦，之前的所有付出都不会白费。

因此，我们的低代码开发方法不仅可以加速整个开发过程，还可以提高软件的质量。


[TBD]


## 编码

### 创建一个 MUD 应用

首先，创建一个 MUD 项目。
你可以参考这里的介绍：https://mud.dev/quickstart#installation


### 编写 DDDML 模型文件

已经写好的模型文件见本代码库的目录 `./dddml`.

> **Tip**
>
> 关于 DDDML，这里有一篇介绍文章：["Introducing DDDML: The Key to Low-Code Development for Decentralized Applications"](https://github.com/wubuku/Dapp-LCDP-Demo/blob/main/IntroducingDDDML.md).


### 生成代码

在代码库的跟目录，执行：

```shell
docker run \
-v .:/myapp \
wubuku/dddappp-mud:master \
--dddmlDirectoryPath /myapp/dddml \
--boundedContextName Hello.Mud \
--mudProjectDirectoryPath /myapp \
--boundedContextJavaPackageName org.dddml.suiinfinitesea \
--javaProjectsDirectoryPath /myapp/mud-java-service \
--javaProjectNamePrefix hellomud \
--pomGroupId dddml.hellomud \
--enableMultipleMoveProjects
```

这个操作会创建（或修改）这个文件：`packages/contracts/mud.config.ts`，以及生成模型中定义的方法对应的业务逻辑实现的 Solidity 脚手架代码。

> **Hint**
>
> 有时候你可能需要删除旧的容器和镜像，以使用最新的镜像：
>
> ```shell
> docker rm $(docker ps -aq --filter "ancestor=wubuku/dddappp-mud:master")
> docker rmi wubuku/dddappp-mud:master
> ```


使用 MUD 的工具生成其他代码：

```shell
pnpm mud tablegen
pnpm mud worldgen
```


### 实现操作业务逻辑

In the directory `packages/contracts/src/systems`, you can see a number of files generated with the suffix `Logic.sol`.

在目录 `packages/contracts/src/systems` 中，你会看到一些后缀为 `Logic.sol` 的文件。

你需要这些文件中实现模型中定义的方法对应的操作业务逻辑。


### 让 AI 发挥作用

因为我们已经开发过游戏的 Move 版本，在 AI 的帮助下，我们可以快速地将 Move 代码转换为 Solidity 代码。

我们把 Move 版本的代码拷贝到低代码工具生成的 `XxxLogic.sol` 文件中，放置在一个注释块里面 `/* Move 版本的业务逻辑实现代码 */`，
然后让 AI 先生成代码。使用提示词：

```text
请将当前文件（注释中）的 Move 代码转换为 Solidity 版本。代码的缩进量为两个空格。提示：Move 是类 Rust 的智能合约语言。转换请考虑语言的特性差异和 Solidity 的最佳实践。错误处理尽可能使用 revert；在 revert error 时尽可能将相关信息放入参数内。比如：`revert InitiatorBattleIdMismatch(battleId1, battleId2)`。请不要修改需要实现的函数的签名；如果有什么信息不知如何获取，请声明一个变量作为占位符，然后使用这个占位符继续生成代码。请使用 TODO 注释详细标注接下来可能需要开发者手动调整的代码。
```

我们发现，大多数情况下，AI 可以生成相当不错的 Solidity 代码。我们往往只需要做一些细微的调整，就可以让代码工作。


## 测试合约

```shell
pnpm dev
```

### 测试 "Counter" 合约

注意将占位符 `__PRIVATE_KEY__` 替换为你实际的私钥：

```shell
cast send --private-key __PRIVATE_KEY__ \
0x8D8b6b8414E1e3DcfD4168561b9be6bD3bF6eC4B \
'app__counterIncrease()'
```

查询 counter 的记录：

```shell
cast call \
0x8D8b6b8414E1e3DcfD4168561b9be6bD3bF6eC4B \
'getRecord(bytes32,bytes32[])' \
0x74626170700000000000000000000000436f756e746572000000000000000000 \
'[]'
```

> **Tip**
>
> 注意，Counter 表的 Resource ID 为 `0x74626170700000000000000000000000436f756e746572000000000000000000`：
> 
> * `tb` 的 ASCII 的十六进制表示: `0x7462`;
> * `app`: `0x617070`;
> * `Counter`: `0x436f756e746572`.
> 
> 关于 Resource IDs，可以参考此链接的说明：[MUD Resource IDs](https://mud.dev/world/resource-ids).

### 测试 "Position" 合约

创建一个 position 记录：

```shell
cast send --private-key __PRIVATE_KEY__ \
0x8D8b6b8414E1e3DcfD4168561b9be6bD3bF6eC4B \
'app__positionCreate(address,int32,int32,string)' \
'0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266' \
'1' '2' 'hello'
```

查询 emit 出来的事件：

```shell
cast logs 'PositionCreatedEvent(address,int32,int32,string)'
```

更新 position 记录：

```shell
cast send --private-key __PRIVATE_KEY__ \
0x8D8b6b8414E1e3DcfD4168561b9be6bD3bF6eC4B \
'app__positionUpdate(address,int32,int32,string)' \
'0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266' \
'1' '2' 'world'
```

查询 emit 出来的事件：

```shell
cast logs 'PositionUpdatedEvent(address,int32,int32,string)'
```

### 测试 "Terrain" 合约

创建一个 terrain 记录：

```shell
cast send --private-key __PRIVATE_KEY__ \
0x8D8b6b8414E1e3DcfD4168561b9be6bD3bF6eC4B \
'app__terrainCreate(int32,int32,string,uint8[],bytes)' \
'1' '2' 'hello' '[0x01]' '0x01'
```

查询 emit 出来的事件：

```shell
cast logs 'TerrainCreatedEvent(int32,int32,string,uint8[],bytes)'
```

更新 terrain 记录：

```shell
cast send --private-key __PRIVATE_KEY__ \
0x8D8b6b8414E1e3DcfD4168561b9be6bD3bF6eC4B \
'app__terrainUpdate(int32,int32,string,uint8[],bytes)' \
'1' '2' 'world' '[0x01]' '0x01'
```

查询 emit 出来的事件：

```shell
cast logs 'TerrainUpdatedEvent(int32,int32,string,uint8[],bytes)'
```
