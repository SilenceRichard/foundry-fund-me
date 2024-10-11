// SPDX-License-Identify: MIT

// 1. Deploy mocks when we are on a local anvil chain
// 2.Keep track of contract address across different chains
// Sepolia ETH/USD
// Mainnet ETH/USD
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelpConfig is Script {
    NetWorkConfig public activeNetWorkConfig;
    struct NetWorkConfig {
        address priceFeed;
    }
    uint8 constant DECIMALS = 8;
    int256 constant PRICE = 2000e8;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetWorkConfig = getSepoliaEthConfig();
        } else {
            activeNetWorkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetWorkConfig memory) {
        // price feed address
        NetWorkConfig memory sepoliaConfig = NetWorkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetWorkConfig memory) {
        // 1. Depoly the mocks
        // 2. Return the mock address
        if (activeNetWorkConfig.priceFeed != address(0)) {
            return activeNetWorkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, PRICE);
        vm.stopBroadcast();

        NetWorkConfig memory anvilConfig = NetWorkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }
}
