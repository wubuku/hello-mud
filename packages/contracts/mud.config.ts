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
        x: "uint32",
        y: "uint32",
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
        articleId: "uint64",
        commentSeqId: "uint64",
      },
      key: ["articleId"],
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
    AccountPlayer: {
      schema: {
        accountAddress: "address",
        playerId: "uint256",
      },
      key: ["accountAddress"],
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
        claimedIslandX: "uint32",
        claimedIslandY: "uint32",
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
    Roster: {
      schema: {
        playerId: "uint256",
        sequenceNumber: "uint32",
        status: "uint8",
        speed: "uint32",
        baseExperience: "uint32",
        environmentOwned: "bool",
        updatedCoordinatesX: "uint32",
        updatedCoordinatesY: "uint32",
        coordinatesUpdatedAt: "uint64",
        targetCoordinatesX: "uint32",
        targetCoordinatesY: "uint32",
        originCoordinatesX: "uint32",
        originCoordinatesY: "uint32",
        sailDuration: "uint64",
        setSailAt: "uint64",
        currentSailSegment: "uint16",
        shipBattleId: "uint256",
        shipIds: "uint256[]",
      },
      key: ["playerId", "sequenceNumber"],
    },
    SailIntPointCount: {
      schema: {
        playerId: "uint256",
        sequenceNumber: "uint32",
        count: "uint64",
      },
      key: ["playerId", "sequenceNumber"],
    },
    SailIntPoint: {
      schema: {
        playerId: "uint256",
        sequenceNumber: "uint32",
        index: "uint64",
        coordinatesX: "uint32",
        coordinatesY: "uint32",
        segmentShouldStartAt: "uint64",
      },
      key: ["playerId", "sequenceNumber", "index"],
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
        existing: "bool",
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
    EnergyDrop: {
      schema: {
        accountAddress: "address",
        lastDroppedAt: "uint64",
      },
      key: ["accountAddress"],
    },
    IslandClaimWhitelist: {
      schema: {
        accountAddress: "address",
        existing: "bool",
        allowed: "bool",
      },
      key: ["accountAddress"],
    },
    Counter: {
      schema: {
        value: "uint32",
      },
      key: [],
    },
    Map: {
      schema: {
        existing: "bool",
        islandClaimWhitelistEnabled: "bool",
      },
      key: [],
    },
    MapLocation: {
      schema: {
        x: "uint32",
        y: "uint32",
        type_: "uint32",
        occupiedBy: "uint256",
        gatheredAt: "uint64",
        existing: "bool",
        resourcesItemIds: "uint32[]",
        resourcesQuantities: "uint32[]",
      },
      key: ["x", "y"],
    },
    ExperienceTable: {
      schema: {
        existing: "bool",
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
    EnergyToken: {
      schema: {
        tokenAddress: "address",
      },
      key: [],
    },
  },
  systems: {
    PlayerFriendSystem: {
      openAccess: false,
    },
    ShipFriendSystem: {
      openAccess: false,
    },
    RosterFriendSystem: {
      openAccess: false,
    },
    RosterSailingSystem: {
      openAccess: false,
    },
    RosterCleaningSystem: {
      openAccess: false,
    },
    SkillProcessFriendSystem: {
      openAccess: false,
    },
    MapFriendSystem: {
      openAccess: false,
    },
  },
  modules: [
  ],
});
