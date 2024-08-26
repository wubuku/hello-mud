# READ ME

This is a PoC (Proof of Concept) for developing a dapp based on the MUD framework using a low-code approach.

## Why would we do this?

Simply put, it's all about more efficient development.

While MUD is a great development framework, it has some limitations.

First, it is an abstraction at the "programming" level.
Programming is not the whole story of software development.
Especially for complex software development, programming is not even the most time-consuming part of the development process.
A low-code development approach can accelerate the entire development process.

Second, it is tightly coupled to the EVM/Solidity ecosystem. We can't use it to develop dapps for other ecosystems.

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
--boundedContextSuiPackageName infinite_sea \
--boundedContextJavaPackageName org.dddml.suiinfinitesea \
--javaProjectsDirectoryPath /myapp/mud-java-service \
--javaProjectNamePrefix hellomud \
--pomGroupId dddml.hellomud \
--enableMultipleMoveProjects
```

The above will create (modify) the file `packages/contracts/mud.config.ts`.

> **Hint**
>
> Sometimes you may need to remove old containers and images:
>
> ```shell
> docker rm $(docker ps -aq --filter "ancestor=wubuku/dddappp-mud:master")
> docker rmi wubuku/dddappp-sui:master
> ```


Generate MUD code:

```shell
pnpm mud tablegen
pnpm mud worldgen
```


### Implementing operation business logic

In the directory `packages/contracts/src/systems`, you can see a number of files generated with the suffix `Logic.sol`.

You can implement the operation business logic in these files.

## Test contracts

```shell
pnpm dev
```

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
> * `Couter`: `0x43x6f756e746572`.
> 
> About the Resource IDs, can refer to this link: [MUD Resource IDs](https://mud.dev/world/resource-ids).


### Test "Position" contract

Create a position record:

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


