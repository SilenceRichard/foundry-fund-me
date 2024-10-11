// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/PriceConverter.sol"; // 修改为实际的路径
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceConverterTest is Test {
    address constant priceFeedAddress =
        0x694AA1769357215DE4FAC081bf1f309aDC325306;

    // Mock Aggregator's latestRoundData to return a fixed price
    function testGetPrice() public {
        // 设置返回值：假设返回 ETH 价格为 3000.00 USD
        int256 mockedPrice = 3000;

        // mock AggregatorV3Interface's latestRoundData function call
        vm.mockCall(
            priceFeedAddress, // 价格源地址
            abi.encodeWithSelector(
                AggregatorV3Interface.latestRoundData.selector
            ), // mock 方法选择器
            abi.encode(0, mockedPrice, 0, 0, 0) // 模拟返回的 roundId, answer(价格), startedAt, timestamp, answeredInRound
        );

        // 调用 getPrice
        int price = PriceConverter.getPrice();
        console.log("price:", price);
        assertEq(price, mockedPrice); // 验证返回值是否正确
    }

    // Mock Aggregator and test getConversionRate
    function testGetConversionRate() public {
        // 假设 ETH 价格为 3000 USD
        int256 mockedPrice = 3000;

        // mock AggregatorV3Interface's latestRoundData function call
        vm.mockCall(
            priceFeedAddress,
            abi.encodeWithSelector(
                AggregatorV3Interface.latestRoundData.selector
            ),
            abi.encode(0, mockedPrice, 0, 0, 0) // 使用与上面相同的 mock 返回值
        );

        uint256 ethAmount = 1e18; // 1 ETH
        uint256 expectedConversionRate = (uint256(mockedPrice) * ethAmount) /
            1e18;

        // 调用 getConversionRate
        uint256 conversionRate = PriceConverter.getConversionRate(ethAmount);
        assertEq(conversionRate, expectedConversionRate); // 验证返回值是否正确
    }
}
