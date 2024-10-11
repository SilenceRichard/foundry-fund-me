// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MockV3Aggregator {
    int256 private price;
    uint8 private _decimals;
    int256 public version;

    // 设置价格的小数位数和初始价格
    constructor(uint8 decimals, int256 initialPrice) {
        _decimals = decimals;
        price = initialPrice;
        version = 4;
    }

    // 返回价格的小数位数，和 Chainlink 的 Aggregator V3 接口一样
    function decimals() external view returns (uint8) {
        return _decimals;
    }

    // 返回当前价格数据，类似于 Chainlink 的 latestRoundData 函数
    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        roundId = 0; // 模拟 roundId
        answer = price; // 返回当前的模拟价格
        startedAt = block.timestamp; // 当前时间作为 startedAt
        updatedAt = block.timestamp; // 当前时间作为 updatedAt
        answeredInRound = roundId; // 模拟 answeredInRound
    }

    // 用于更新模拟的价格值
    function updatePrice(int256 newPrice) external {
        price = newPrice;
    }

    function getVersion() external view returns (int256) {
        return version;
    }
}
