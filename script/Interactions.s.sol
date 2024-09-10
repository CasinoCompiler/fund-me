// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Script, console} from "../lib/forge-std/src/Script.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 SEND_VALUE = 0.1 ether;

    function fundFundMe(address _mostRecentDeployment) public {
        vm.startBroadcast();
        FundMe(payable(_mostRecentDeployment)).fundWithEth{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded with %s", SEND_VALUE);
    }

    function run() external {
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        fundFundMe(mostRecentDeployment);
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address _mostRecentDeployment) public {
        vm.startBroadcast();
        FundMe(payable(_mostRecentDeployment)).cheaperWithdraw();
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        withdrawFundMe(mostRecentDeployment);
    }
}
