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
