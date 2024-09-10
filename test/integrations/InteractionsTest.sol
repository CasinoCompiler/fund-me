// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test, console} from "../../lib/forge-std/src/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/FundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    DeployFundMe deployFundMe;
    FundMe fundMe;
    FundFundMe fundFundMe;
    WithdrawFundMe withdrawFundMe;

    address USER = makeAddr("user");
    uint256 USER_STARTING_BALANCE = 10 ether;
    uint256 SEND_1_ETH = 1 ether;

    function setUp() external {
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, USER_STARTING_BALANCE);
    }

    function testUserCanFund() public {
        fundFundMe = new FundFundMe();
        vm.deal(USER, USER_STARTING_BALANCE);
        fundFundMe.fundFundMe(address(fundMe));
    }

    function testUserCanWithdraw() public {
        withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));
    }
}
