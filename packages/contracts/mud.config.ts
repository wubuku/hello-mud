import { defineWorld } from "@latticexyz/world";

export default defineWorld({
  namespace: "app",
  tables: {
    Counter: {
      schema: {
        value: "uint32",
      },
      key: [],
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
  },
  systems: {
    CounterSystem: {
      //name: "increment",
      //openAccess: true,
    },
  },
});
