import { defineWorld } from "@latticexyz/world";

export default defineWorld({
  namespace: "app",
  tables: {
    Position: {
      schema: {
        player: "address",
        x: "int32",
        y: "int32",
        description: "string",
      },
      key: ["player"],
    },
    Terrain: {
      schema: {
        x: "int32",
        y: "int32",
        terrainType: "string",
        foo: "uint8[]",
        bar: "bytes",
      },
      key: ["x", "y"],
    },
    ArticleIdGenerator: {
      schema: {
        id: "uint64",
      },
      key: [],
    },
    Article: {
      schema: {
        id: "uint64",
        author: "address",
        title: "string",
        body: "string",
      },
      key: ["id"],
    },
    ArticleTagCount: {
      schema: {
        articleId: "uint64",
        count: "uint64",
      },
      key: ["articleId"],
    },
    CommentSeqIdGenerator: {
      schema: {
        commentSeqId: "uint64",
      },
      key: [],
    },
    Comment: {
      schema: {
        articleId: "uint64",
        commentSeqId: "uint64",
        commenter: "string",
        body: "string",
      },
      key: ["articleId", "commentSeqId"],
    },
    ArticleTag: {
      schema: {
        articleId: "uint64",
        tagIndex: "uint64",
        tag: "string",
      },
      key: ["articleId", "tagIndex"],
    },
    PlayerIdGenerator: {
      schema: {
        id: "uint256",
      },
      key: [],
    },
    Player: {
      schema: {
        id: "uint256",
        owner: "address",
        level: "uint16",
        experience: "uint32",
        x: "int32",
        y: "int32",
        name: "string",
      },
      key: ["id"],
    },
    PlayerInventoryCount: {
      schema: {
        playerId: "uint256",
        count: "uint64",
      },
      key: ["playerId"],
    },
    PlayerInventory: {
      schema: {
        playerId: "uint256",
        inventoryIndex: "uint64",
        inventoryItemId: "uint32",
        inventoryQuantity: "uint32",
      },
      key: ["playerId", "inventoryIndex"],
    },
    ShipIdGenerator: {
      schema: {
        id: "uint256",
      },
      key: [],
    },
    Ship: {
      schema: {
        id: "uint256",
        owner: "uint256",
        healthPoints: "uint32",
        attack: "uint32",
        protection: "uint32",
        speed: "uint32",
        buildingExpensesItemIds: "uint32[]",
        buildingExpensesQuantities: "uint32[]",
      },
      key: ["id"],
    },
    ShipInventoryCount: {
      schema: {
        shipId: "uint256",
        count: "uint64",
      },
      key: ["shipId"],
    },
    ShipInventory: {
      schema: {
        shipId: "uint256",
        inventoryIndex: "uint64",
        inventoryItemId: "uint32",
        inventoryQuantity: "uint32",
      },
      key: ["shipId", "inventoryIndex"],
    },
    Roster: {
      schema: {
        playerId: "uint256",
        sequenceNumber: "uint32",
        status: "uint8",
        speed: "uint32",
        coordinatesUpdatedAt: "uint64",
        sailDuration: "uint64",
        setSailAt: "uint64",
        shipBattleId: "uint256",
        environmentOwned: "bool",
        baseExperience: "uint32",
        shipIds: "uint256[]",
      },
      key: ["playerId", "sequenceNumber"],
    },
    Counter: {
      schema: {
        value: "uint32",
      },
      key: [],
    },
    Map: {
      schema: {
        width: "uint32",
        height: "uint32",
      },
      key: [],
    },
    MapLocation: {
      schema: {
        x: "int32",
        y: "int32",
        type_: "uint32",
        occupiedBy: "address",
      },
      key: ["x", "y"],
    },
    ExperienceTable: {
      schema: {
        reservedBool1: "bool",
      },
      key: [],
    },
    XpTableLevelCount: {
      schema: {
        count: "uint64",
      },
      key: [],
    },
    XpTableLevel: {
      schema: {
        index: "uint64",
        level: "uint16",
        experience: "uint32",
        difference: "uint32",
      },
      key: ["index"],
    },
  },
});
