import { defineWorld } from "@latticexyz/world";

export default defineWorld({
  namespace: "app",
  tables: {
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
    Item: {
      schema: {
        itemId: "uint32",
        requiredForCompletion: "bool",
        sellsFor: "uint32",
        name: "string",
      },
      key: ["itemId"],
    },
    ItemCreation: {
      schema: {
        itemCreationIdSkillType: "uint8",
        itemCreationIdItemId: "uint32",
        requirementsLevel: "uint16",
        baseQuantity: "uint32",
        baseExperience: "uint32",
        baseCreationTime: "uint64",
        energyCost: "uint64",
        successRate: "uint16",
        resourceCost: "uint32",
      },
      key: ["itemCreationIdSkillType", "itemCreationIdItemId"],
    },
    ItemProduction: {
      schema: {
        itemProductionIdSkillType: "uint8",
        itemProductionIdItemId: "uint32",
        requirementsLevel: "uint16",
        baseQuantity: "uint32",
        baseExperience: "uint32",
        baseCreationTime: "uint64",
        energyCost: "uint64",
        successRate: "uint16",
        materialItemIds: "uint32[]",
        materialItemQuantities: "uint32[]",
      },
      key: ["itemProductionIdSkillType", "itemProductionIdItemId"],
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
    SkillProcess: {
      schema: {
        skillProcessIdSkillType: "uint8",
        skillProcessIdPlayerId: "uint256",
        skillProcessIdSequenceNumber: "uint8",
        itemId: "uint32",
        startedAt: "uint64",
        creationTime: "uint64",
        completed: "bool",
        endedAt: "uint64",
        batchSize: "uint32",
      },
      key: ["skillProcessIdSkillType", "skillProcessIdPlayerId", "skillProcessIdSequenceNumber"],
    },
    SkillPrcMtrlCount: {
      schema: {
        skillProcessIdSkillType: "uint8",
        skillProcessIdPlayerId: "uint256",
        skillProcessIdSequenceNumber: "uint8",
        count: "uint64",
      },
      key: ["skillProcessIdSkillType", "skillProcessIdPlayerId", "skillProcessIdSequenceNumber"],
    },
    SkillPrcMtrl: {
      schema: {
        skillProcessIdSkillType: "uint8",
        skillProcessIdPlayerId: "uint256",
        skillProcessIdSequenceNumber: "uint8",
        productionMaterialIndex: "uint64",
        productionMaterialItemId: "uint32",
        productionMaterialQuantity: "uint32",
      },
      key: ["skillProcessIdSkillType", "skillProcessIdPlayerId", "skillProcessIdSequenceNumber", "productionMaterialIndex"],
    },
    Position: {
      schema: {
        player: "address",
        x: "int32",
        y: "int32",
        description: "string",
      },
      key: ["player"],
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
        claimedIslandX: "int32",
        claimedIslandY: "int32",
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
    ShipBattleIdGenerator: {
      schema: {
        id: "uint256",
      },
      key: [],
    },
    ShipBattle: {
      schema: {
        id: "uint256",
        initiatorRosterPlayerId: "uint256",
        initiatorRosterSequenceNumber: "uint32",
        responderRosterPlayerId: "uint256",
        responderRosterSequenceNumber: "uint32",
        status: "uint8",
        endedAt: "uint64",
        winner: "uint8",
        roundNumber: "uint32",
        roundStartedAt: "uint64",
        roundMover: "uint8",
        roundAttackerShip: "uint256",
        roundDefenderShip: "uint256",
        initiatorExperiences: "uint32[]",
        responderExperiences: "uint32[]",
      },
      key: ["id"],
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
    ShipIdGenerator: {
      schema: {
        id: "uint256",
      },
      key: [],
    },
    Ship: {
      schema: {
        id: "uint256",
        playerId: "uint256",
        rosterSequenceNumber: "uint32",
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
    Counter: {
      schema: {
        value: "uint32",
      },
      key: [],
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
  },
});
