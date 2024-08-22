# READ ME


## Test contracts

```shell
cast send --private-key __PRIVATE_KEY__ \
0x8D8b6b8414E1e3DcfD4168561b9be6bD3bF6eC4B \
'app__positionCreate(address,int32,int32,string)' \
'0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266' \
'1' '2' 'hello'
```

```shell
cast logs 'PositionCreatedEvent(address,int32,int32,string)'
```

```shell
cast send --private-key __PRIVATE_KEY__ \
0x8D8b6b8414E1e3DcfD4168561b9be6bD3bF6eC4B \
'app__positionUpdate(address,int32,int32,string)' \
'0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266' \
'1' '2' 'world'
```

```shell
cast logs 'PositionUpdatedEvent(address,int32,int32,string)'
```
