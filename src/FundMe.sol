// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "../lib/chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error FundMe__notOwner();

contract FundMe {
    using PriceConverter for uint256;

    address private immutable i_owner;

    AggregatorV3Interface private s_priceFeed;
   
   // Constructor argument is chainlink price feed proxy address for chosen token \\
           // https://docs.chain.link/data-feeds/price-feeds/addresses \\
    constructor(address priceFeedContract) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeedContract);
    }

    // Modifier to ensure the owner is the msg sender
    modifier onlyOwner() {
        // require(msg.sender == i_owner);
        if (msg.sender != i_owner){
            revert FundMe__notOwner();
        }
        _;
    }
    
    // Minimum contribution in usd
    uint256 public constant MIN_USD = 5 * 1e18;

    // Array of funders
    address[] private s_funders;

    // Mapping of funders
    mapping(address  => uint256) private s_addressToAmountFunded;

    function fundWithEth() public payable {
        // Ensure eth amount sent is > minimum contribution 
        require(msg.value.convertPrice(s_priceFeed) > MIN_USD);

        // Update funders array
        s_funders.push(msg.sender);

        // Update mapping with previous contribution + new contribution
        s_addressToAmountFunded[msg.sender] += msg.value;

    }

        // Withdraw all funds to address \\
    function withdraw() public onlyOwner {
        // TRANSFER METHOD:: payable(msg.sender).transfer(address(this).balance);
        // SEND METHOD:: bool sendSuccess = payable(msg.sender).send(address(this).balance) /n require(sendSuccess, "Send Failed")

        // RECOMMENDED CALL METHOD:
        (bool sent,) = payable(msg.sender).call{value: address(this).balance}("");
        require(sent, "Withdraw failed");

        // Clear the mapping. this is best practice
        for(uint256 i = 0; i < s_funders.length; i++){
            s_addressToAmountFunded[s_funders[0]] = 0;
        }

        // Reset the array
        s_funders = new address[](0);
    }

    // Cheaper for loop
    // reading from storage costs alot therefore do not loop reading a storage variable.abi
    function cheaperWithdraw() public onlyOwner {
        uint256 fundersLength = s_funders.length;

        (bool sent,) = payable(msg.sender).call{value: address(this).balance}("");
        require(sent, "Withdraw failed");

        // Clear the mapping. this is best practice
        for(uint256 i = 0; i < fundersLength; i++){
            s_addressToAmountFunded[s_funders[0]] = 0;
        }

        // Reset the array
        s_funders = new address[](0);
    }

    // Getters\\

    // Version representing type of Chainlink aggregator
    function getVersion() public view returns(uint256){
        return s_priceFeed.version();
    }

    function getOwner() public view returns(address){
        return i_owner;
    }

    // Function to get s_funders array
    function getFunder(uint256 index) public view returns(address){
        return s_funders[index];
    }

    // Function to get amount funded from address
    function getAmountFundedForaddress(address _funderAddress) public view returns(uint256){
        return s_addressToAmountFunded[_funderAddress];
    }

    receive() external payable { 
        fundWithEth();
    }

    fallback() external payable { 
        fundWithEth();
    }

}