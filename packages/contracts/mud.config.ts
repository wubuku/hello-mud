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
