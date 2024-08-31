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
  },
});
