// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Script} from "../lib/forge-std/src/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {

            // Sepolia ETH / USD Address \\
    // 0x694AA1769357215DE4FAC081bf1f309aDC325306 \\

    function run() external returns(FundMe) {

        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
