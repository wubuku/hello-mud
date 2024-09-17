// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title TsRandomUtil
 * @dev This library provides utility functions for generating pseudo-random numbers.
 *
 * WARNING: While this library uses multiple sources of blockchain data for randomness,
 * it is still not cryptographically secure. Miners can potentially manipulate these values.
 * DO NOT use this for gambling, cryptographic functions, or any high-stakes applications.
 * For production use cases requiring secure randomness, consider using Chainlink VRF or similar oracle services.
 */
library TsRandomUtil {
  uint32 private constant MAX_U32 = 4_294_967_295;
  uint64 private constant MAX_U64 = 18_446_744_073_709_551_615;

  function getInt(bytes memory seed, uint64 bound) internal view returns (uint64) {
    return uint64(getU256(seed) % bound);
  }

  function get8U32Vector(bytes memory seed) internal view returns (uint32[8] memory) {
    uint256 u_o = getU256(seed);
    return [
      uint32(u_o % MAX_U32),
      uint32((u_o >> 32) % MAX_U32),
      uint32((u_o >> 64) % MAX_U32),
      uint32((u_o >> 96) % MAX_U32),
      uint32((u_o >> 128) % MAX_U32),
      uint32((u_o >> 160) % MAX_U32),
      uint32((u_o >> 192) % MAX_U32),
      uint32((u_o >> 224) % MAX_U32)
    ];
  }

  function get4U64(bytes memory seed) internal view returns (uint64, uint64, uint64, uint64) {
    uint256 u_o = getU256(seed);
    return (
      uint64(u_o % MAX_U64),
      uint64((u_o >> 64) % MAX_U64),
      uint64((u_o >> 128) % MAX_U64),
      uint64((u_o >> 192) % MAX_U64)
    );
  }

  function getU256(bytes memory seed) internal view returns (uint256) {
    bytes memory bs = abi.encodePacked(
      //block.difficulty,
      block.number,
      block.timestamp,
      block.coinbase,
      blockhash(block.number - 1),
      seed
    );
    return uint256(keccak256(bs));
  }

  /**
   * @dev Divides a given value into n pseudo-random parts.
   * @param seed Initial seed for randomness
   * @param value The total value to be divided
   * @param n The number of parts to divide the value into
   * @return An array of n uint64 values that sum up to the original value
   *
   * Note: The randomness used here is not cryptographically secure.
   * Use with caution in production environments.
   */
  function divideInt(bytes memory seed, uint64 value, uint64 n) internal view returns (uint64[] memory) {
    uint64[] memory result = new uint64[](n);
    uint64 remaining = value;
    for (uint64 i = 0; i < n; i++) {
      if (i == n - 1) {
        result[i] = remaining;
        break;
      }
      seed = abi.encodePacked(seed, i);
      uint64 bound = remaining + 1;
      uint64 r = getInt(seed, bound);
      result[i] = r;
      remaining -= r;
    }
    return result;
  }
}
