// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test, console} from "../../lib/forge-std/src/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/FundMe.s.sol";

contract FundMeTest is Test {
    DeployFundMe deployFundMe;
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 USER_STARTING_BALANCE = 10 ether;
    uint256 SEND_1_ETH = 1 ether;

    function setUp() external {
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, USER_STARTING_BALANCE);
    }

    modifier prankFunded(){
        vm.prank(USER);
        fundMe.fundWithEth{value:SEND_1_ETH}();
        _;
    }
 
    // Watch video on visibility
    function test_MinDollarIsFive() external view {
        assertEq(fundMe.MIN_USD(), 5e18);
    }

    function test_OwnerIsMsgSender() external view {
        console.log("Owner: %s, msg.sender: %s, address.this: %s", fundMe.getOwner(), msg.sender, address(this));
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function test_GetVersion() external view {
        console.log("Version: %i", fundMe.getVersion());
        assertEq(fundMe.getVersion(), 4);
    }

    function test_FundFailsFromNotEnough() public {
        vm.expectRevert(); // Command to say next line exe should revert
        fundMe.fundWithEth{value:1e15}(); // Send small amount
        vm.expectRevert();
        fundMe.fundWithEth{value:0}(); // Sending 0 eth 
    }

    function test_UpdateDataStructures() public prankFunded{
        uint256 amountFunded = fundMe.getAmountFundedForaddress(USER);
        assertEq(amountFunded, SEND_1_ETH);

    }

    function test_FunderGetsAddedToArray() public prankFunded{
        assertEq(fundMe.getFunder(0), USER);
    }

    function test_OnlyOwnerCanWithdraw() public prankFunded {
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }

    function test_OwnerCanWithdrawWithOtherFunders() public prankFunded{
        // Arrange \\
        address owner = fundMe.getOwner();
        uint256 startingOwnerBalance = owner.balance;
        
        // Act \\
        vm.prank(owner);
        fundMe.withdraw();

        // Assert \\
        assertGt(owner.balance, startingOwnerBalance);
        // Ensure entire balance is withdrawn
        assertEq(address(fundMe).balance, 0);

    }

    function test_WithdrawWithMultipleFunders() public prankFunded{
        // Arange \\
        // get multiple funders to fund fundMe
        uint160 numberofFunders = 10;
        for(uint160 i = 1; i < numberofFunders; i++){
            hoax(address(i), SEND_1_ETH);
            fundMe.fundWithEth{value:SEND_1_ETH}();
        }

        address owner = fundMe.getOwner();
        uint256 startingOwnerBalance = owner.balance;

        // Act \\
        vm.prank(owner);
        fundMe.withdraw();

        // Assert \\
        assertGt(owner.balance, startingOwnerBalance);
        // Ensure entire balance is withdrawn
        assertEq(address(fundMe).balance, 0);

    }

    function test_WithdrawWithMultipleFundersCheaper() public prankFunded{
        // Arange \\
        // get multiple funders to fund fundMe
        uint160 numberofFunders = 10;
        for(uint160 i = 1; i < numberofFunders; i++){
            hoax(address(i), SEND_1_ETH);
            fundMe.fundWithEth{value:SEND_1_ETH}();
        }

        address owner = fundMe.getOwner();
        uint256 startingOwnerBalance = owner.balance;

        // Act \\
        vm.prank(owner);
        fundMe.cheaperWithdraw();
        
        // Assert \\
        assertGt(owner.balance, startingOwnerBalance);
        // Ensure entire balance is withdrawn
        assertEq(address(fundMe).balance, 0);

    }
}
