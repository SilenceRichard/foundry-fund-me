// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(
        AggregatorV3Interface priceFeed
    ) internal view returns (int) {
        // ABI
        // Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        (
            ,
            // uint80 roundI5t643D,
            int answer, // uint startedAt, // uint timeStamp, // uint80 answeredInRound
            ,
            ,

        ) = priceFeed.latestRoundData();
        // ETH in terms of USD
        // 3000.00000000
        return answer;
    }

    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        int ethPrice = getPrice(priceFeed);
        uint256 ethAmountInUsd = (uint256(ethPrice) * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}
