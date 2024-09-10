// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Script} from "../lib/forge-std/src/Script.sol";
import {MockV3Aggregator} from "../test//mocks/MockV3Aggregator.sol";

// 1. Deploy mocks when we are on a local anvil network
// 2. Keep track of contract addresses across different chains

// If we are on a local anvil chain, deploy mock
// Otherwise, grab existing address fom the live network
contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    uint8 constant DECIMALS = 8;
    int256 constant INITIAL_PRICE = 2000e8;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaConfig;
    }

    function getOrCreateAnvilConfig() public returns (NetworkConfig memory) {
        MockV3Aggregator mockPriceFeed;
        NetworkConfig memory anvilConfig;

        // Ensure an anvil mock address hasn't already been deployed. if it has, return existing config.
        if (activeNetworkConfig.priceFeed != address(0)) {
            return anvilConfig;
        }

        vm.startBroadcast();
        mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        anvilConfig = NetworkConfig({priceFeed: address(mockPriceFeed)});
        return anvilConfig;
    }
}
