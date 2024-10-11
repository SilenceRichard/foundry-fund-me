// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import {Test} from "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/FundMe.sol";
import {DepolyFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe public fundMe;

    function setUp() public {
        // 部署合约
        DepolyFundMe deployFundMe = new DepolyFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinUSDisOne() public view {
        assertEq(fundMe.minimumUSD(), 1e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    // function testFund() public {
    //     vm.deal(address(2), 10 ether);
    //     // addr2 向合约发送 1 ETH
    //     vm.prank(address(2)); // 模拟 addr2
    //     fundMe.fund{value: 1 ether}();

    //     // 验证存款金额
    //     uint256 amountFunded = fundMe.addressToAmountFunded(address(2));
    //     assertEq(amountFunded, 1 ether);
    // }
}
