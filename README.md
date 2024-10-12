# Developing EVM Dapps using a low-code approach

English | [中文版](./README_CN.md)

This is a demonstration for developing dapps with MUD framework in a low-code way.


The core of low-code is "model-driven."
We will show how to use a DSL (Domain Specific Language) called DDDML to describe the application's domain model.
The domain model is then converted into the MUD config (model) file and Solidity contracts to speed up the application development process.


> We are currently porting the fully on-chain game [Infinite Seas](http://infiniteseas.io) to EVM.
> 
> In the `./dddml` directory of the current repository, you can see most of the DDDML model files we designed for Infinite Seas.
> We have included them as part of this example so that you can see the practical application of DDDML.
> 
> We use almost identical model files to drive the development of both the Sui version and the Aptos version of Infinite Seas.
> Those familiar with the Move ecosystem should know that although both Sui and Aptos use the Move language, they have significant differences in many details, especially in state storage mechanisms.
> 
> In the current Web3 development landscape, only a highly abstract and concise DSL like DDDML allows us to port a complex decentralized application so effortlessly.


## Motivation

Some may ask: why not just use MUD framework directly if you're doing things on top of a MUD?

Simply put: for more efficient development.

While MUD is a great development framework, it has some limitations.

The most obvious point is that it is tightly coupled with the EVM/Solidity ecosystem;
we can't use it to develop decentralized applications for other ecosystems.

Also, although MUD claims to be a general-purpose application development framework,
not just for on-chain game development; 
in reality, most developers still see it as a FOCG (Fully On-Chain Game) engine.
For on-chain game development, MUD does not introduce any off-chain hybrid solutions to achieve a higher tickrate for the game.
It may be that the intention of MUD was to be as on-chain as possible, but it is clear that this is a limitation rather than an advantage.

We believe that adopting a model-driven low-code development approach not only provides greater efficiency, but also can address these shortcomings of MUD.

You may have noticed that MUD also has the concept of "data models,"
but they are at a different level of abstraction compared to the domain models used in our low-code approach.

The models defined in MUD's config files are lower-level "physical data models."
They can essentially be seen as part of the program's implementation code.

We all know that programming implementation is not the entirety of software development.
Especially for complex software development, it is not even the most time-consuming part of the process.
To develop high quality software, we need to put enough effort in the analysis and design phases.
We also need to ensure that the implementation code reflects the results of the analysis and top-level design,
and only then will the code have good maintainability.

Our low-code development approach uses domain models in the style of DDD (Domain-Driven Design).
DDD domain models are an organic combination of Object-Oriented Analysis (OOA) models and Object-Oriented Design (OOD) models.

We have designed a highly expressive DSL to describe these domain models.
We can even use it to build **conceptual** domain models during the requirements analysis phase of software development;
during the design and coding phases, we build upon the same model, ensuring that all previous efforts are not wasted.

Therefore, our low-code development approach can not only accelerate the entire development process but also improve the quality of the software.


[TBD]


## Programming

### Create MUD application

First, create a MUD project.
You can refer to the introduction here: https://mud.dev/quickstart#installation


### Writing DDDML model files

The model files are located in the directory `./dddml`.

> **Tip**
>
> About DDDML, here is an introductory article: ["Introducing DDDML: The Key to Low-Code Development for Decentralized Applications"](https://github.com/wubuku/Dapp-LCDP-Demo/blob/main/IntroducingDDDML.md).


### Generating code

In repository root directory, run:

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

The above will create (modify) the file `packages/contracts/mud.config.ts`,
as well as scaffold Solidity code for the business logic implementation corresponding to the methods defined in the model.


> **Hint**
>
> Sometimes you may need to remove old containers and images, ensure you are using the latest image:
>
> ```shell
> docker rm $(docker ps -aq --filter "ancestor=wubuku/dddappp-mud:master")
> docker rmi wubuku/dddappp-mud:master
> ```


Generate other code using MUD tools:

```shell
pnpm mud tablegen
pnpm mud worldgen
```


### Implementing operation business logic

In the directory `packages/contracts/src/systems`, you can see a number of files generated with the suffix `Logic.sol`.

You can implement the operation business logic in these files.


### Leveraging AI


#### AI-assisted code migration

In the process of porting the game to EVM, we found that using AI-assisted code generation could further improve development efficiency.

Since we have already developed the Move version of the game, with the help of AI, we can quickly convert Move code to Solidity code.

We copy the Move version of the code into the `XxxYyyLogic.sol` files generated by the low-code tool, placing it within a comment block `/* Move version of the business logic implementation code */`. Then we let the AI generate the code first. We use the following prompt:

```text
Please convert the Move code in the current file (in comments) to a Solidity version. 
The code indentation should be two spaces. Note: Move is a Rust-like smart contract language. 
When converting, please consider the differences in language features and Solidity best practices. 
Error handling should use `revert` as much as possible; 
when using `revert error`, include relevant information in the parameters when possible. 
For example: `revert InitiatorBattleIdMismatch(battleId1, battleId2)`. 
Please do not modify the signatures of the functions to be implemented; 
if there's any information you don't know how to obtain, please declare a variable as a placeholder and then continue generating code using the placeholder. 
Please use TODO comments to detail any code that may need manual adjustment by the developer later.
```

We've found that in most cases, AI can generate quite good Solidity code. We often only need to make some minor adjustments to make the code work.


#### AI-assisted business logic code writing

So, what if there's no Move version of the code available for reference?

Let's conduct some experiments. Now, our dddappp low-code tool can embed model information into the comments of the generated `XxxYyyLogic.sol` scaffold code.
You might think these comments are excessively long and tedious to look at;
however, our main purpose is to allow AI (and of course, you) to refer to these comments to complete the business logic code.

In [Cursor IDE](https://www.cursor.com), we guide the AI to do "fill-in-the-blank" coding for business logic in this way:
* Open the business logic implementation code file `XxxYyyLogic.sol`.
* Use the shortcut Cmd + A to select all the code in the current file. (I'm using macOS, for Windows systems, replace Cmd with Ctrl.)
* Use the shortcut Cmd + L to open Cursor's CHAT window (I'm using the claude-3.5-sonnet model).
* Add reference files to the CHAT window as needed. Which files to reference are actually hinted at in the comments of our generated code.
* Enter prompts (see the table below) to let AI attempt to complete the function coding.

We tested three files, with the following results:

File Name | Prompt | File Before AI Gen. | File After AI Gen. | Files Referenced in Prompt
--- | --- | --- | --- | ---
CounterIncreaseLogic.sol | Complete the functions. | [Link](https://gist.github.com/wubuku/d7a45b868cb8f21b74e41127baf3b28e) | [Link](https://gist.github.com/wubuku/2b3691a9af146316d2811774868eb932) | 
SkillProcessCreateLogic.sol | Read the comments of the current file, and the file I referenced @SkillType.sol , and complete the functions in the current file. | [Link](https://gist.github.com/wubuku/ac4f965f5c467190e89cf2128fe0ef7e) | [Link](https://gist.github.com/wubuku/f1b71f20d448edb2e10f53232fa7cb10) | `SkillType.sol`
ArticleAddTagLogic.sol | Read the comments of the current file, and the files I referenced @ArticleTag.sol @ArticleTagLib.sol , and complete the functions in the current file. | [Link](https://gist.github.com/wubuku/02d6c25e66b6f60afce9f57ba29af2bc) | [Link](https://gist.github.com/wubuku/8b017449e511dac569456df8f4a3d6fe) | `ArticleTag.sol`, `ArticleTagLib.sol`

It's worth noting that in these three examples, the code generated by AI passed compilation on the first attempt, and we believe there are no obvious problems. The results are **indeed impressive**!

> The results above are a true record of our experiments. Just to be clear, though, the code generated by the AI is not stable, and you won't get the same results every time.

You can compare the AI-generated code with the "handwritten" versions in our current repository to see the differences—in fact, the discrepancies are quite minor.


## Test Infinite Seas contracts

```shell
pnpm dev
```

### Infinite Seas "smoke" tests

After deployment, you can manually run the following "smoke" tests 
(you may need to adjust the parameters in the test scripts as needed):

```shell
forge script script/ManualSmokeTest.s.sol:ManualSmokeTest --sig "run(address)" __WORLD_ADDRESS__ --broadcast --rpc-url http://localhost:8545

forge script script/ShipInventoryTransferTest.s.sol:ShipInventoryTransferTest --sig "run(address)" __WORLD_ADDRESS__ --broadcast --rpc-url http://localhost:8545

forge script script/ShipBattleTest.s.sol:ShipBattleTest --sig "run(address)" __WORLD_ADDRESS__ --broadcast --rpc-url http://localhost:8545

forge script script/GatherIslandResourcesTest.s.sol:GatherIslandResourcesTest --sig "run(address)" __WORLD_ADDRESS__ --broadcast --rpc-url http://localhost:8545
```

### Infinite Seas "roster sailing" tests

After deployment, run this smoke test first:

```shell
forge script script/ManualSmokeTest.s.sol:ManualSmokeTest --sig "run(address)" __WORLD_ADDRESS__ --broadcast --rpc-url http://localhost:8545
```

Then run this SetSail test:

```shell
forge script script/RosterSetSailTest.s.sol:RosterSetSailTest --sig "run(address)" __WORLD_ADDRESS__ --broadcast --rpc-url http://localhost:8545
```

Repeat this test several times, watching the Logs output:

```shell
forge script script/RosterUpdateLocationTest.s.sol:RosterUpdateLocationTest --sig "run(address)" __WORLD_ADDRESS__ --broadcast --rpc-url http://localhost:8545
```

After repeating the execution a number of times, the error `RosterNotUnderway` will be reported, 
which means that the sailing is complete.


SetSail biz logic implementation is here: [RosterSetSailLogic.sol](./packages/contracts/src/systems/RosterSetSailLogic.sol).

UpdateLocation biz logic implementation is here: [RosterUpdateLocationLogic.sol](./packages/contracts/src/systems/RosterUpdateLocationLogic.sol).


## Test other demo contracts


### Test "Counter" contract

Notice replacing the placeholder `__PRIVATE_KEY__` with your actual private key:

```shell
cast send --private-key __PRIVATE_KEY__ \
0x8D8b6b8414E1e3DcfD4168561b9be6bD3bF6eC4B \
'app__counterIncrease()'
```

Queries the record of counter:

```shell
cast call \
0x8D8b6b8414E1e3DcfD4168561b9be6bD3bF6eC4B \
'getRecord(bytes32,bytes32[])' \
0x74626170700000000000000000000000436f756e746572000000000000000000 \
'[]'
```

> **Tip**
>
> Notice that the Resource ID of the Counter table is `0x74626170700000000000000000000000436f756e746572000000000000000000`.
> 
> * The ASCII hex of `tb`: `0x7462`;
> * `app`: `0x617070`;
> * `Counter`: `0x436f756e746572`.
> 
> About the Resource IDs, can refer to this link: [MUD Resource IDs](https://mud.dev/world/resource-ids).


### Test "Blog" contract


Create an article:

```shell
cast send --private-key __PRIVATE_KEY__ \
0x8D8b6b8414E1e3DcfD4168561b9be6bD3bF6eC4B \
'app__articleCreate(address,string,string)' \
'0x8D8b6b8414E1e3DcfD4168561b9be6bD3bF6eC4B' 'hello' 'world'
```

Add a comment to the article:

```shell
cast send --private-key __PRIVATE_KEY__ \
0x8D8b6b8414E1e3DcfD4168561b9be6bD3bF6eC4B \
'app__articleAddComment(uint64,string,string)' \
'1' 'Jeff' 'A test comment'
```


### Test "Position" contract

Create a position record (assuming that the world contract address is `0x8D8b6b8414E1e3DcfD4168561b9be6bD3bF6eC4B`):

```shell
cast send --private-key __PRIVATE_KEY__ \
0x8D8b6b8414E1e3DcfD4168561b9be6bD3bF6eC4B \
'app__positionCreate(address,int32,int32,string)' \
'0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266' \
'1' '2' 'hello'
```

View events emitted:

```shell
cast logs 'PositionCreatedEvent(address,int32,int32,string)'
```

Update the position record:

```shell
cast send --private-key __PRIVATE_KEY__ \
0x8D8b6b8414E1e3DcfD4168561b9be6bD3bF6eC4B \
'app__positionUpdate(address,int32,int32,string)' \
'0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266' \
'1' '2' 'world'
```

View events emitted:

```shell
cast logs 'PositionUpdatedEvent(address,int32,int32,string)'
```

### Test "Terrain" contract

Create a terrain record:

```shell
cast send --private-key __PRIVATE_KEY__ \
0x8D8b6b8414E1e3DcfD4168561b9be6bD3bF6eC4B \
'app__terrainCreate(int32,int32,string,uint8[],bytes)' \
'1' '2' 'hello' '[0x01]' '0x01'
```

View events emitted:

```shell
cast logs 'TerrainCreatedEvent(int32,int32,string,uint8[],bytes)'
```

Update the terrain record:

```shell
cast send --private-key __PRIVATE_KEY__ \
0x8D8b6b8414E1e3DcfD4168561b9be6bD3bF6eC4B \
'app__terrainUpdate(int32,int32,string,uint8[],bytes)' \
'1' '2' 'world' '[0x01]' '0x01'
```

View events emitted:

```shell
cast logs 'TerrainUpdatedEvent(int32,int32,string,uint8[],bytes)'
```



### Test "Article" contract

Create an article:

```shell
cast send --private-key __PRIVATE_KEY__ \
0x8D8b6b8414E1e3DcfD4168561b9be6bD3bF6eC4B \
'app__articleCreate(address,string,string)' \
'0x8D8b6b8414E1e3DcfD4168561b9be6bD3bF6eC4B' 'hello' 'world'
```

View events emitted:

```shell
cast logs 'ArticleCreatedEvent(uint64,address,string,string)'
```

Add a tag to the article:

```shell
cast send --private-key __PRIVATE_KEY__ \
0x8D8b6b8414E1e3DcfD4168561b9be6bD3bF6eC4B \
'app__articleAddTag(uint64,string)' \
'1' 'foo'
```

View events emitted:

```shell
cast logs 'TagAddedEvent(uint64,string)'
```

Queries the record of article-tag count (the second parameter is key tuple):

```shell
cast call \
0x8D8b6b8414E1e3DcfD4168561b9be6bD3bF6eC4B \
'getRecord(bytes32,bytes32[])' \
0x7462617070000000000000000000000041727469636c65546167436f756e7400 \
'[0x0000000000000000000000000000000000000000000000000000000000000001]'
```

> The ASCII hex of `ArticleTagCount`: `41727469636c65546167436f756e74`.