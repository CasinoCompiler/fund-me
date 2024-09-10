// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {AggregatorV3Interface} from "../lib/chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        (, int256 price,,,) = priceFeed.latestRoundData();
        return uint256(price * 1e10);
    }

    function convertPrice(uint256 amount, AggregatorV3Interface priceFeed) internal view returns (uint256) {
        uint256 price = getPrice(priceFeed);
        uint256 priceConverted = (price * amount) / 1e18;
        return priceConverted;
    }
}
